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
	
	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		_allowUITestToManageDictionaries()
		prepareKeyboardAvoidance()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		showKeyboardOnLaunch()
	}
}

// MARK:- Affordances for UI Testing
extension AddWordViewController
{
	/// For UI Testing, show the system dictionary immediately, to allow the test code to set up at least one dictionary.
	private func _allowUITestToManageDictionaries()
	{
		if ProcessInfo.processInfo.arguments.contains("UITEST")
			&& prefs.shouldDisplayFirstUseDictionaryPrompt()
		{
			let dictionaryViewController = UIReferenceLibraryViewController(term: "Kotoba")
			present(dictionaryViewController, animated: true, completion: nil)
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

// MARK:- Show keyboard on launch
extension AddWordViewController
{
	func showKeyboardOnLaunch()
	{
		self.textField.becomeFirstResponder()
	}
}

// MARK:- Missing API of Optional
extension Optional
{
	/// Return `nil` if `includeElement` evaluates to `false`.
	func filter(_ includeElement: (Wrapped) -> Bool) -> Optional<Wrapped>
	{
		return flatMap { includeElement($0) ? self : nil }
	}
}

// MARK:- Text Field delegate
extension AddWordViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.text
			.flatMap(Word.init)
			.filter(showDefinition) // Search the dictionary (stops here when word is not found)
			.map(words.add) // Add word to list of words
			.map { textField.text = nil } // Clear the text field when word is successfully found
		return true
	}
}
