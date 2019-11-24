//
//  AddWordViewController.swift
//  Kotoba
//
//  Created by Will Hains on 06/17.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation
import UIKit

final class AddWordViewController: UITableViewController
{
//	@IBOutlet weak var textField: UITextField!
	
	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		prepareKeyboardAvoidance()
		
		let titleFont = UIFont.init(name: "AmericanTypewriter-Semibold", size: 22) ?? UIFont.systemFont(ofSize: 22.0, weight: .bold)
		let titleColor = UIColor.init(named: "appBarText") ?? UIColor.white
		self.navigationController?.navigationBar.titleTextAttributes = [ .font: titleFont, .foregroundColor: titleColor ]
		
		NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		debugLog()
		super.viewWillAppear(animated)
//		showKeyboard()
	}
	
	@objc func applicationDidBecomeActive(notification: NSNotification)
	{
		debugLog()
//		checkPasteboard()
		checkMigration()
	}
}

// MARK:- Async word lookup
// Solution donated by Craig Hockenberry
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
//					DispatchQueue.main.async { self.textField.text = nil }
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
}

// MARK:- Keyboard avoiding
// Solution adapted from http://stackoverflow.com/a/16044603/554518
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

	@objc func keyboardWillShow(notification: Notification)
	{
		let info = notification.userInfo!
		let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
		additionalSafeAreaInsets.bottom = keyboardSize

		let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
	}

	@objc func keyboardWillHide(notification: Notification)
	{
		let info = notification.userInfo!
		additionalSafeAreaInsets.bottom = 0

		let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
	}
}

private let _LAST_PASTEBOARD_TEXT_KEY = "last_pasteboard_text"

// MARK:- Launch behaviour
extension AddWordViewController
{
//	func showKeyboard()
//	{
//		self.textField.becomeFirstResponder()
//	}
//
//	func checkPasteboard()
//	{
//		if let text = UIPasteboard.general.string?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//		{
//			// ignore text that has newlines in it
//			if text.rangeOfCharacter(from: CharacterSet.newlines) == nil
//			{
//				// ignore text that hasn't changed since the last time we ran
//				let lastPasteboardText = UserDefaults.standard.string(forKey: _LAST_PASTEBOARD_TEXT_KEY)
//				if text != lastPasteboardText
//				{
//					self.textField.text = text
//
//					let alert = UIAlertController(
//						title: "Search with Clipboard",
//						message: """
//						This text is on the clipboard:
//
//						\(text)
//
//						Do you want to use it for a search?
//						""",
//						preferredStyle: .alert)
//					let alertAction = UIAlertAction(title: "Search", style: .default)
//					{
//						_ in
//						let word = Word.init(text: text)
//						self.initiateSearch(forWord: word)
//					}
//					alert.addAction(alertAction)
//					let preferredAction = UIAlertAction(title: "Ignore", style: .default)
//					{
//						_ in
//						self.textField.text = nil
//					}
//					alert.addAction(preferredAction)
//					alert.preferredAction = preferredAction
//					self.present(alert, animated: true, completion: nil)
//
//					UserDefaults.standard.set(text, forKey: _LAST_PASTEBOARD_TEXT_KEY)
//				}
//			}
//		}
//	}
	
	func checkMigration()
	{
		if WordList.useRemote
		{
			if WordList.hasLocalData
			{
				let alert = UIAlertController(
					title: "Migrate to iCloud",
					message: "Do you want to add the words in the local list to iCloud?",
					preferredStyle: .alert)
				let alertAction = UIAlertAction(title: "Keep on Local", style: .default)
				{
					_ in
					WordList.useRemote = false
				}
				alert.addAction(alertAction)
				let preferredAction = UIAlertAction(title: "Add to iCloud", style: .default)
				{
					_ in
					self.migrateWordsToRemote()
				}
				alert.addAction(preferredAction)
				alert.preferredAction = preferredAction
				self.present(alert, animated: true, completion: nil)
			}
		}
		else
		{
			if WordList.hasRemoteData
			{
				let alert = UIAlertController(
					title: "Migrate to Local Storage",
					message: "Do you want to move the word list from iCloud to local storage?",
					preferredStyle: .alert)
				let alertAction = UIAlertAction(title: "Move to Local", style: .default)
				{
					_ in
					debugLog("migrating remote data")
					self.migrateWordsToLocal()
				}
				alert.addAction(alertAction)
				let preferredAction = UIAlertAction(title: "Keep on iCloud", style: .default)
				{
					_ in
					debugLog("keeping remote data")
					WordList.useRemote = true
				}
				alert.addAction(preferredAction)
				alert.preferredAction = preferredAction
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	func migrateWordsToRemote()
	{
		let localWords = WordList(local: true)
		let indices = 0..<localWords.count // NOTE: would be cleaner if WordList was a Sequence
		for index in indices
		{
			let localWord = localWords[index]
			words.add(word: localWord)
		}
		localWords.remove()
	}

	func migrateWordsToLocal()
	{
		let remoteWords = WordList(local: false)
		let indices = 0..<remoteWords.count // NOTE: would be cleaner if WordList was a Sequence
		for index in indices
		{
			let remoteWord = remoteWords[index]
			words.add(word: remoteWord)
		}
		remoteWords.remove()
	}
}

// MARK:- Text Field delegate
extension AddWordViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		if let text = textField.text
		{
			let word = Word.init(text: text)
			initiateSearch(forWord: word)
		}
		
		return true
	}
}

extension AddWordViewController
{
	private var pasteboardWords: [Word]
	{
		// TODO: Remove punctuation.
		// TODO: Filter out too-simple words ("to", "and", "of", etc.).
		// TODO: Filter out non-words and likely passwords (digits, symbols).
		// TODO: Tokenise words in locale-independent way (not whitespace).
		// TODO: De-duplicate.
		UIPasteboard.general.string?.components(separatedBy: .whitespacesAndNewlines).map(Word.init) ?? []
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return pasteboardWords.count + 1
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return indexPath.row == 0 ? 95 : super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		if indexPath.row == 0
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Entry", for: indexPath)
			// TODO: Set delegate of the text field to self
			return cell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = pasteboardWords[indexPath.row - 1].text
		cell.textLabel?.font = .preferredFont(forTextStyle: UIFont.TextStyle.body) // TODO: Move to extension of UILabel
		return cell
	}
}
