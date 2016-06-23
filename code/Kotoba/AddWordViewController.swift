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
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}

// MARK:- Keyboard avoiding
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
	
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		
		// Show the keyboard on launch, so you can start typing right away
		self.textField.becomeFirstResponder()
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

// MARK:- Text Field delegate
extension AddWordViewController: UITextFieldDelegate
{
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		// Search the dictionary
		if let word = textField.text.map(Word.init)
		{
			if showDefinitionForWord(word)
			{
				// Add word to list of words
				words.addWord(word)
				
				// Clear the text field when word is successfully found
				textField.text = nil
			}
		}
		return true
	}
}
