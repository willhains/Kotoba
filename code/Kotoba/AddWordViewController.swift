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
	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!

	deinit
	{
		// This is for keyboard avoiding, but `deinit` can't be moved into an extension :(
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}

// MARK:- Keyboard avoiding
// Solution adapted from http://stackoverflow.com/a/16044603/554518
extension AddWordViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(AddWordViewController.keyboardWillShow(_:)),
			name:UIKeyboardWillShowNotification,
			object: nil);
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(AddWordViewController.keyboardWillHide(_:)),
			name:UIKeyboardWillHideNotification,
			object: nil);
	}

	func keyboardWillShow(sender: NSNotification)
	{
		let info = sender.userInfo!
		let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
		bottomConstraint.constant = (keyboardSize - bottomLayoutGuide.length)

		let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
	}

	func keyboardWillHide(sender: NSNotification)
	{
		let info = sender.userInfo!
		bottomConstraint.constant = 44

		let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
	}
}

// MARK:- Show keyboard on launch
extension AddWordViewController
{
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		self.textField.becomeFirstResponder()
	}
}

// MARK:- Missing API of Optional
extension Optional
{
	/// Return `nil` if `includeElement` evaluates to `false`.
	func filter(@noescape includeElement: (Wrapped) -> Bool) -> Optional<Wrapped>
	{
		return flatMap { includeElement($0) ? self : nil }
	}
}

// MARK:- Text Field delegate
extension AddWordViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		// Search the dictionary
		if let word = textField.text.map(Word.init).filter(showDefinitionForWord)
		{
			// Add word to list of words
			words.addWord(word)
			
			// Clear the text field when word is successfully found
			textField.text = nil
		}
		return true
	}
}
