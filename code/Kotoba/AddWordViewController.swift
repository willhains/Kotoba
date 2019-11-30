//
//  AddWordViewController.swift
//  Kotoba
//
//  Created by Will Hains on 06/17.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation
import UIKit

final class AddWordViewController: UIViewController
{
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var suggestionView: UIView!
	@IBOutlet weak var suggestionLabel: UILabel!
	@IBOutlet weak var suggestionToggleButton: UIButton!

	@IBOutlet weak var typingViewBottomLayoutConstraint: NSLayoutConstraint!
	@IBOutlet weak var suggestionViewBottomLayoutConstraint: NSLayoutConstraint!
	@IBOutlet weak var suggestionViewHeightLayoutConstraint: NSLayoutConstraint!

	var suggestionsVisible = false
	var suggestionHeight = CGFloat(200)
	let suggestionHeaderHeight = CGFloat(44) // NOTE: This value should match "Header View" in the storyboard

	var haveSuggestions = false // NOTE: This value is true if the pasteboard contained text the last time it was checked
	var sourcePasteboardString: String?
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
		prepareKeyboardAvoidance()

		self.title = UserDefaults.standard.CHOCKTUBA_DUH ? "CHOCKTUBA" : "Kotoba"
		self.textField.placeholder = UserDefaults.standard.CHOCKTUBA_DUH ? "TYPE HERE DUH" : "Type a Word"
		self.suggestionLabel?.text = UserDefaults.standard.CHOCKTUBA_DUH ? "TYPE IT LAZY ASS" : "Clipboard Suggestions"
		
		let titleFont = UIFont.init(name: "AmericanTypewriter-Semibold", size: 22) ?? UIFont.systemFont(ofSize: 22.0, weight: .bold)
		let titleColor = UIColor.init(named: "appBarText") ?? UIColor.white
		self.navigationController?.navigationBar.titleTextAttributes = [ .font: titleFont, .foregroundColor: titleColor ]

		suggestionsVisible = !UIPasteboard.general.ignoreSuggestions
		// NOTE: Check the pasteboard before we update the layout of the view for initial presentation
		updateFromPasteboard()

//		self.suggestionViewHeightLayoutConstraint.constant = suggestionHeight
//		updateConstraintsForKeyboardAndSuggestions()
//		updateLayersForSuggestions()

		// NOTE: This improves the initial view animation, when the keyboard and suggestions appear.
		//self.view.layoutIfNeeded()
		// it also generates this warning
/*
		[TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window. Table view: <UITableView: 0x7f8064035e00; frame = (0 44; 414 156); clipsToBounds = YES; autoresize = RM+BM; gestureRecognizers = <NSArray: 0x600001310b10>; layer = <CALayer: 0x600001d2d2c0>; contentOffset: {0, 0}; contentSize: {414, 0}; adjustedContentInset: {0, 0, 0, 0}; dataSource: <Kotoba.AddWordViewController: 0x7f806370ac80>>
		*/
		
		NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
		
		//startMonitoringPasteboard()
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		debugLog()
		super.viewWillAppear(animated)

		
		
		// NOTE: This improves the initial view animation, when the keyboard and suggestions appear.
//		self.view.layoutIfNeeded()
//		tableView.reloadData()
		
		//showKeyboard()

//		updateConstraintsForKeyboard()

		// NOTE: This improves the initial view animation, when the keyboard and suggestions appear.
//		self.view.setNeedsLayout()

	}
	
	override func viewDidAppear(_ animated: Bool) {
		debugLog()
		super.viewDidAppear(animated)

//		self.view.layoutIfNeeded()
		showKeyboard()
	}
	
	@objc func applicationDidBecomeActive(notification: NSNotification)
	{
		debugLog()
//		checkMigration()
		
		let duration: TimeInterval = 0.2
		UIView.animate(withDuration: duration) {
			self.updateFromPasteboard()
			self.view.layoutIfNeeded()
		}
	}
}

// MARK:- Async word lookup
// Solution donated by Craig Hockenberry
// WILL: I appreciate the nod, but it's a slippery slope considering the number of other changes I've maded and folks can dig through commits if they really want to blame someone :-)
extension AddWordViewController
{
	func initiateSearch(forWord word: Word)
	{
		debugLog("word = \(word)")
		
		// NOTE: On iOS 13, UIReferenceLibraryViewController got slow, both to return a view controller and do
		// a definition lookup. Previously, Kotoba did both these things at the same time on the same queue.
		//
		// The gymnastics below are to hide the slowness: after the view controller is presented, the definition lookup
		// proceeds on a background queue. If there's a definition, the text field is cleared: if you spend little time
		// reading the definition, you'll notice that the field is cleared while you're looking at it. If you're really
		// quick, you can see it not appear in the History view, too. Better this than slowness.
		
		self.showDefinition(forWord: word)
		{
			debugLog("presented dictionary view controlller")
			
			DispatchQueue.global().async
			{
				debugLog("checking definition")
				let hasDefinition = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.text)
				debugLog("hasDefinition = \(hasDefinition)")
				if hasDefinition
				{
					words.add(word: word)
					DispatchQueue.main.async
					{
						self.textField.text = nil
					}
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
		if let url = URL.init(string: UIApplication.openSettingsURLString)
		{
			UIApplication.shared.open(url)
		}
	}
	
	@IBAction func dismissSuggestions(_: AnyObject)
	{
		debugLog()

		//UserDefaults.standard.set(sourcePasteboardString, forKey:_HIDDEN_PASTEBOARD_TEXT_KEY)
		self.suggestionsVisible.toggle()
		UIPasteboard.general.ignoreSuggestions = !suggestionsVisible

		let duration: TimeInterval = 0.2
		UIView.animate(withDuration: duration) {
			self.updateConstraintsForKeyboardAndSuggestions()
			self.updateLayersForSuggestions()
			self.view.layoutIfNeeded()
		}
	}

}

// MARK:- Keyboard notifications
extension AddWordViewController
{
	func prepareKeyboardAvoidance()
	{
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(AddWordViewController.keyboardWillShow(notification:)),
			name:UIResponder.keyboardWillShowNotification,
			object: nil);
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(AddWordViewController.keyboardWillHide(notification:)),
			name:UIResponder.keyboardWillHideNotification,
			object: nil);
	}

	private func updateConstraintsForKeyboardAndSuggestions()
	{
		// NOTE: There are two primary views, each with a layout contraint for the bottom of the view.
		//
		// The first is the "suggestion view" that attaches either to the top of the keyboard (when shown) or a negative offset
		// of its height (to hide the view.)
		//
		// The second view is the "typing view" that is either attached to the top of the suggestion view (when its visible) or
		// to the bottom safe area inset (when its not.)
		
		self.suggestionViewHeightLayoutConstraint.constant = suggestionHeight
		
		if self.suggestionsVisible	{
			if self.keyboardVisible {
				self.typingViewBottomLayoutConstraint.constant = keyboardHeight + suggestionHeight
				self.suggestionViewBottomLayoutConstraint.constant = keyboardHeight
			}
			else {
				self.typingViewBottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom + suggestionHeight
				self.suggestionViewBottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom
			}
		}
		else {
			if self.keyboardVisible {
				self.typingViewBottomLayoutConstraint.constant = keyboardHeight
				self.suggestionViewBottomLayoutConstraint.constant = keyboardHeight - suggestionHeight + suggestionHeaderHeight
			}
			else {
				self.typingViewBottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom
				self.suggestionViewBottomLayoutConstraint.constant = 0 - suggestionHeight + suggestionHeaderHeight
			}
		}
	}
	
	private func updateLayersForSuggestions()
	{
		if self.suggestionsVisible	{
			self.suggestionToggleButton.layer.transform = CATransform3DIdentity;
		}
		else {
			self.suggestionToggleButton.layer.transform = CATransform3DMakeRotation(CGFloat.pi * 1/4, 0, 0, 1);
		}
	}

	@objc func keyboardWillShow(notification: Notification)
	{
		let info = notification.userInfo!
		keyboardVisible = true
		keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
		
		let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration) {
			self.updateConstraintsForKeyboardAndSuggestions()
			self.view.layoutIfNeeded()
		}
	}

	@objc func keyboardWillHide(notification: Notification)
	{
		let info = notification.userInfo!
		keyboardVisible = false
		keyboardHeight = 0

		let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration) {
			self.updateConstraintsForKeyboardAndSuggestions()
			self.view.layoutIfNeeded()
		}
	}

}

//private let _HIDDEN_PASTEBOARD_TEXT_KEY = "hidden_pasteboard_text"

// MARK:- Utility
extension AddWordViewController
{
	func showKeyboard()
	{
		self.textField.becomeFirstResponder()
	}

	func updateFromPasteboard()
	{
		// TODO: layout isn't right if pasteboard is empty
		
		pasteboardWords = UIPasteboard.general.suggestedWords
		tableView.reloadData()
		if (pasteboardWords.count > 0) {
			tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
		}
		
		// TODO: make sure that maximumHeight takes landscape orientation into account (e.g. compact height will require a shorter height
		let maximumHeight = CGFloat(200)
		
		var computedSuggestionHeight = suggestionHeaderHeight
		for row in 0..<pasteboardWords.count {
			if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
				computedSuggestionHeight += cell.frame.size.height
			}
			else {
				computedSuggestionHeight += 44
			}
			if computedSuggestionHeight > maximumHeight {
				break
			}
		}
		if computedSuggestionHeight > maximumHeight {
			suggestionHeight = maximumHeight
		}
		else {
			suggestionHeight = computedSuggestionHeight
		}

		suggestionsVisible = !UIPasteboard.general.ignoreSuggestions
		
		updateConstraintsForKeyboardAndSuggestions()
		updateLayersForSuggestions()
	}

//	func checkPasteboard()
//	{
//		let hiddenPasteboardString = UserDefaults.standard.string(forKey: _HIDDEN_PASTEBOARD_TEXT_KEY)
//
//		haveSuggestions = false
//		if let currentPasteboardString = UIPasteboard.general.string {
//			haveSuggestions = true
//			if currentPasteboardString != hiddenPasteboardString {
//				sourcePasteboardString = UserDefaults.standard.CHOCKTUBA_DUH ? currentPasteboardString.uppercased() : currentPasteboardString
//
//				// TODO: Filter out too-simple words ("to", "and", "of", etc.).
//				// TODO: Filter out non-words and likely passwords (digits, symbols).
//				pasteboardWords = sourcePasteboardString?
//					.trimmingCharacters(in: .whitespacesAndNewlines)
//					.words
//					.deDuplicate()
//					.map(Word.init)
//					?? []
//
//				suggestionsVisible = true
//
//				updateConstraintsForKeyboardAndSuggestions()
//				updateLayersForSuggestions()
//			}
//
//		}
//
//		tableView.reloadData()
//	}

	/*
	func checkPasteboard()
	{
		if let text = UIPasteboard.general.string?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		{
			// ignore text that has newlines in it
			if text.rangeOfCharacter(from: CharacterSet.newlines) == nil
			{
				// ignore text that hasn't changed since the last time we ran
				let lastPasteboardText = UserDefaults.standard.string(forKey: _LAST_PASTEBOARD_TEXT_KEY)
				if text != lastPasteboardText
				{
					self.textField.text = text
					
					let alert = UIAlertController(
						title: "Search with Clipboard",
						message: """
						This text is on the clipboard:
						
						\(text)
						
						Do you want to use it for a search?
						""",
						preferredStyle: .alert)
					let alertAction = UIAlertAction(title: "Search", style: .default)
					{
						_ in
						let word = Word.init(text: text)
						self.initiateSearch(forWord: word)
					}
					alert.addAction(alertAction)
					let preferredAction = UIAlertAction(title: "Ignore", style: .default)
					{
						_ in
						self.textField.text = nil
					}
					alert.addAction(preferredAction)
					alert.preferredAction = preferredAction
					self.present(alert, animated: true, completion: nil)
					
					UserDefaults.standard.set(text, forKey: _LAST_PASTEBOARD_TEXT_KEY)
				}
			}
		}
	}
	*/

//	func checkMigration()
//	{
//		if WordList.useRemote
//		{
//			if WordList.hasLocalData
//			{
//				let alert = UIAlertController(
//					title: "Migrate to iCloud",
//					message: "Do you want to add the words in the local list to iCloud?",
//					preferredStyle: .alert)
//				let alertAction = UIAlertAction(title: "Keep on Local", style: .default)
//				{
//					_ in
//					WordList.useRemote = false
//				}
//				alert.addAction(alertAction)
//				let preferredAction = UIAlertAction(title: "Add to iCloud", style: .default)
//				{
//					_ in
//					self.migrateWordsToRemote()
//				}
//				alert.addAction(preferredAction)
//				alert.preferredAction = preferredAction
//				self.present(alert, animated: true, completion: nil)
//			}
//		}
//		else
//		{
//			if WordList.hasRemoteData
//			{
//				let alert = UIAlertController(
//					title: "Migrate to Local Storage",
//					message: "Do you want to move the word list from iCloud to local storage?",
//					preferredStyle: .alert)
//				let alertAction = UIAlertAction(title: "Move to Local", style: .default)
//				{
//					_ in
//					debugLog("migrating remote data")
//					self.migrateWordsToLocal()
//				}
//				alert.addAction(alertAction)
//				let preferredAction = UIAlertAction(title: "Keep on iCloud", style: .default)
//				{
//					_ in
//					debugLog("keeping remote data")
//					WordList.useRemote = true
//				}
//				alert.addAction(preferredAction)
//				alert.preferredAction = preferredAction
//				self.present(alert, animated: true, completion: nil)
//			}
//		}
//	}
//
//	func migrateWordsToRemote()
//	{
//		let localWords = WordList(local: true)
//		let indices = 0..<localWords.count // NOTE: would be cleaner if WordList was a Sequence
//		for index in indices
//		{
//			let localWord = localWords[index]
//			words.add(word: localWord)
//		}
//		localWords.remove()
//	}
//
//	func migrateWordsToLocal()
//	{
//		let remoteWords = WordList(local: false)
//		let indices = 0..<remoteWords.count // NOTE: would be cleaner if WordList was a Sequence
//		for index in indices
//		{
//			let remoteWord = remoteWords[index]
//			words.add(word: remoteWord)
//		}
//		remoteWords.remove()
//	}
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

////  Adapted from https://medium.com/@sorenlind/three-ways-to-enumerate-the-words-in-a-string-using-swift-7da5504f0062
//extension String
//{
//	var words: [String]
//	{
//        var words = [String]()
//		if let range = range(of: self)
//		{
//			self.enumerateSubstrings(in: range, options: .byWords)
//			{
//				(substring, _, _, _) -> () in
//				words.append(substring!)
//			}
//		}
//        return words
//    }
//}

//extension Array where Element: Hashable
//{
//	// WILL: This name feels clumsy. Maybe go with .removingDuplicates() or something more like .trimmingCharacters()
//	func deDuplicate() -> Array<Element>
//	{
//		var deDuped: [Element] = []
//		var uniques: Set<Element> = Set()
//		for element in self
//		{
//			if !uniques.contains(element)
//			{
//				uniques.insert(element)
//				deDuped.append(element)
//			}
//		}
//		return deDuped
//	}
//}

extension AddWordViewController: UITableViewDelegate, UITableViewDataSource
{
//	private var pasteboardWords: [Word]
//	{
//		// WILL: Computed properties can hide complexity in Swift. There is a fair amount of string processing happening each time
//		// you access pasteboardWords (by index or getting a count). The underlying data doesn't change much (if at all) so another
//		// mechanism is needed. This is related to the other note below about polling the clipboard.
//
//		// TODO: Filter out too-simple words ("to", "and", "of", etc.).
//		// TODO: Filter out non-words and likely passwords (digits, symbols).
//		UIPasteboard.general.string?
//			.trimmingCharacters(in: .whitespacesAndNewlines)
//			.words
//			.deDuplicate()
//			.map(Word.init)
//			?? []
//	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return pasteboardWords.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = pasteboardWords[indexPath.row].text
		cell.textLabel?.font = .preferredFont(forTextStyle: UIFont.TextStyle.body) // TODO: Move to extension of UILabel
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		guard indexPath.row >= 0 else { return }
		let word = pasteboardWords[indexPath.row]
		initiateSearch(forWord: word)
		tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
	}
}

/*
extension AddWordViewController: PasteboardWatcherDelegate
{
	private func startMonitoringPasteboard()
	{
		let pasteboard = PasteboardWatcher()
		pasteboard.delegate = self
		pasteboard.startPolling(every: 1)
	}
	
	func pasteboardStringDidChange(newValue: String)
	{
		// WILL: This is problematic in two ways:
		//
		// 1) It can happen during an animation and affect table view constraints.
		//
		// 2) It's based on polling, which uses a timer, which doesn't run in the background and may behave unpredicably entering foreground (see #1).
		
		//self.tableView.reloadData()
	}
}
*/

