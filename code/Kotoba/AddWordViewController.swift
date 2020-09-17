//
//  Created by Will Hains on 06/17.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation
import UIKit

class AddWordViewController: UIViewController
{
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchingIndicator: UIActivityIndicatorView!

	@IBOutlet weak var suggestionToggleButton: UIButton!

	@IBOutlet weak var typingViewBottomLayoutConstraint: NSLayoutConstraint!
	@IBOutlet weak var suggestionViewBottomLayoutConstraint: NSLayoutConstraint!
	@IBOutlet weak var suggestionViewHeightLayoutConstraint: NSLayoutConstraint!

	var suggestionsVisible = false
	var suggestionHeight = CGFloat(200)
	let suggestionHeaderHeight = CGFloat(44) // NOTE: This value should match "Header View" in the storyboard

	var pasteboardWords: [Word] = []

	var keyboardVisible = false
	var keyboardHeight = CGFloat(0)

	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}

	override func viewDidLoad()
	{
		super.viewDidLoad()
		prepareKeyboardNotifications()

		// NOTE: This improves the initial view animation, when the keyboard and suggestions appear, but it also
		// generates the warning below. If we wait until the tableView is in the view hierarchy (in viewDidAppear) the
		// keyboard animation is already in progress and it's too late to adjust the width of the top-level view.
		self.view.layoutIfNeeded()

		/*
		[TableView] Warning once only: UITableView was told to layout its visible cells and other contents without
		being in the view hierarchy (the table view or one of its superviews has not been added to a window). This
		may cause bugs by forcing views inside the table view to load and perform layout without accurate information
		(e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause
		unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at
		UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to
		occur, so you can avoid this action altogether if possible, or defer it until the table view has been added
		to a window. Table view: <UITableView: 0x7f8064035e00; frame = (0 44; 414 156); clipsToBounds = YES;
		autoresize = RM+BM; gestureRecognizers = <NSArray: 0x600001310b10>; layer = <CALayer: 0x600001d2d2c0>;
		contentOffset: {0, 0}; contentSize: {414, 0}; adjustedContentInset: {0, 0, 0, 0}; dataSource: <Kotoba
		.AddWordViewController: 0x7f806370ac80>>
		*/

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(applicationDidBecomeActive(notification:)),
			name: UIApplication.didBecomeActiveNotification,
			object: nil)
	}

	override func viewWillAppear(_ animated: Bool)
	{
		debugLog()
		super.viewWillAppear(animated)

		// TODO: Decide if the keyboard should appear before or after the view.
		showKeyboard()
	}

	override func viewDidAppear(_ animated: Bool)
	{
		debugLog()
		super.viewDidAppear(animated)
	}

	override func viewWillDisappear(_ animated: Bool)
	{
		debugLog()
		super.viewWillDisappear(animated)

		hideKeyboard()
	}

	@objc func applicationDidBecomeActive(notification: NSNotification)
	{
		debugLog()

		#if true
			suggestionsVisible = !UIPasteboard.general.ignoreSuggestions
			let duration: TimeInterval = 0.2
			UIView.animate(withDuration: duration)
			{
				self.updateLayoutFromPasteboard()
				self.updateLayersForSuggestions()
				self.updateTableView()
				self.view.layoutIfNeeded()
			}
		#endif
	}
}

// MARK:- Async word lookup
extension AddWordViewController
{
	func initiateSearch(forWord word: Word)
	{
		debugLog("word = \(word)")
		self.searchingIndicator.startAnimating()

		// NOTE: On iOS 13, UIReferenceLibraryViewController got slow, both to return a view controller and do a
		// definition lookup. Previously, Kotoba did both these things at the same time on the same queue.
		//
		// The gymnastics below are to hide the slowness: after the view controller is presented, the definition lookup
		// proceeds on a background queue. If there's a definition, the text field is cleared: if you spend little time
		// reading the definition, you'll notice that the field is cleared while you're looking at it. If you're really
		// quick, you can see it not appear in the History view, too. Better this than slowness.
		//
		// TODO: This has to be a regression in UIReferenceLibraryViewController. I'll file a radar for this.

		self.showDefinition(forWord: word)
		{
			debugLog("presented dictionary view controlller")

			DispatchQueue.global().async
			{
				debugLog("checking definition")
				let hasDefinition = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.text)
				debugLog("hasDefinition = \(hasDefinition)")
				DispatchQueue.main.async
				{
					if hasDefinition
					{
						var words = wordListStore.data
						words.add(word: word)
						self.textField.text = nil
					}
					self.searchingIndicator.stopAnimating()
				}
			}
		}
	}
}

// MARK:- Actions
extension AddWordViewController
{
	@IBAction func openSettings(_: AnyObject)
	{
		debugLog()
		if let url = URL(string: UIApplication.openSettingsURLString)
		{
			UIApplication.shared.open(url)
		}
	}

	@IBAction func dismissSuggestions(_: AnyObject)
	{
		debugLog()

		self.suggestionsVisible.toggle()
		UIPasteboard.general.ignoreSuggestions = !suggestionsVisible

		let duration: TimeInterval = 0.2
		UIView.animate(withDuration: duration)
		{
			self.updateConstraintsForKeyboardAndSuggestions()
			self.updateLayersForSuggestions()
			self.view.layoutIfNeeded()
		}
	}
}

// MARK:- Keyboard notifications
extension AddWordViewController
{
	func prepareKeyboardNotifications()
	{
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(AddWordViewController.keyboardWillShow(notification:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil);
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(AddWordViewController.keyboardWillHide(notification:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil);
	}

	private func updateConstraintsForKeyboardAndSuggestions()
	{
		debugLog("keyboardHeight = \(keyboardHeight), suggestionHeight = \(suggestionHeight)")

		// NOTE: There are two primary views, each with a layout contraint for the bottom of the view.
		//
		// The first is the "suggestion view" that attaches either to the top of the keyboard (when shown) or a
		// negative offset of its height (to hide the view.)
		//
		// The second view is the "typing view" that is either attached to the top of the suggestion view (when it's
		// visible) or to the bottom safe area inset (when it's not.)

		self.suggestionViewHeightLayoutConstraint.constant = suggestionHeight

		if self.suggestionsVisible
		{
			if self.keyboardVisible
			{
				self.typingViewBottomLayoutConstraint.constant = keyboardHeight + suggestionHeight
				self.suggestionViewBottomLayoutConstraint.constant = keyboardHeight
			}
			else
			{
				self.typingViewBottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom + suggestionHeight
				self.suggestionViewBottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom
			}
		}
		else
		{
			if self.keyboardVisible
			{
				self.typingViewBottomLayoutConstraint.constant = keyboardHeight + suggestionHeaderHeight
				self.suggestionViewBottomLayoutConstraint.constant =
					keyboardHeight - suggestionHeight + suggestionHeaderHeight
			}
			else
			{
				// TODO: Technically, the safeAreaInsets are the "bottom", but that leaves a weird little bit of the
				//  first suggestion visible under the home indicator. If the offset is flush against the container view
				//  (e.g. 0), it puts the button and text in the home indicator area. Choose the lesser evil...
//				let offset = self.view.safeAreaInsets.bottom
				let offset = CGFloat.zero
				self.typingViewBottomLayoutConstraint.constant = offset + suggestionHeaderHeight
				self.suggestionViewBottomLayoutConstraint.constant = offset - suggestionHeight + suggestionHeaderHeight
			}
		}
	}

	func updateLayersForSuggestions()
	{
		debugLog()

		if self.suggestionsVisible
		{
			self.suggestionToggleButton.layer.transform = CATransform3DIdentity;
		}
		else
		{
			self.suggestionToggleButton.layer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0)
		}
	}

	@objc func keyboardWillShow(notification: Notification)
	{
		let info = notification.userInfo!
		keyboardVisible = true
		keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

		debugLog("keyboardHeight = \(keyboardHeight)")

		let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration)
		{
			self.updateConstraintsForKeyboardAndSuggestions()
			self.view.layoutIfNeeded()
		}
	}

	@objc func keyboardWillHide(notification: Notification)
	{
		debugLog()

		let info = notification.userInfo!
		keyboardVisible = false
		keyboardHeight = 0

		let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration)
		{
			self.updateConstraintsForKeyboardAndSuggestions()
			self.view.layoutIfNeeded()
		}
	}
}

// MARK:- Utility
extension AddWordViewController
{
	func showKeyboard()
	{
		self.textField.becomeFirstResponder()
	}

	func hideKeyboard()
	{
		self.textField.resignFirstResponder()
	}

	func updateLayoutFromPasteboard()
	{
		pasteboardWords = UIPasteboard.general.suggestedWords

		// NOTE: This isn't the most elegant way to handle the compact height layout (landscape orientation)
		// but it gets the job done with a minimum amount of work. I'm actually questioning the need for
		// landscape support: the entire experience feels kinda clunky.
		// CHOCK: I'd be happy to drop landscape support, tbh.
		let maximumHeight: CGFloat = view.frame.size.height > view.frame.size.width ? 200 : 100

		var computedSuggestionHeight = suggestionHeaderHeight
		for row in 0..<pasteboardWords.count
		{
			if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
			{
				computedSuggestionHeight += cell.frame.size.height
			}
			else
			{
				computedSuggestionHeight += 44
			}
			if computedSuggestionHeight > maximumHeight
			{
				break
			}
		}
		if computedSuggestionHeight > maximumHeight
		{
			suggestionHeight = maximumHeight
		}
		else
		{
			suggestionHeight = computedSuggestionHeight
		}

		suggestionsVisible = !UIPasteboard.general.ignoreSuggestions

		updateConstraintsForKeyboardAndSuggestions()
		updateLayersForSuggestions()
	}

	func updateTableView()
	{
		tableView.reloadData()
		if (pasteboardWords.count > 0)
		{
			tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
		}
	}
}

// MARK:- Text Field delegate
extension AddWordViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		if let text = textField.text
		{
			let word = Word(text: text)
			initiateSearch(forWord: word)
		}

		return true
	}
}

// MARK:- Table View delegate/datasource
extension AddWordViewController: UITableViewDelegate, UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		pasteboardWords.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		let text = pasteboardWords[indexPath.row].text
		cell.textLabel?.text = text
		cell.textLabel?.font = .preferredFont(forTextStyle: UIFont.TextStyle.body) // TODO: Move to extension of UILabel
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		guard indexPath.row >= 0 else { return }
		let word = pasteboardWords[indexPath.row]
		self.textField.text = word.text
		initiateSearch(forWord: word)
		tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
	}
}
