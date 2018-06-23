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
  @IBOutlet weak var speakWordButton: UIButton!
  
	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}
	
  override func viewDidLoad()
	{
		super.viewDidLoad()
		prepareKeyboardAvoidance()
    observeTextField()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		showKeyboardOnLaunch()
    hideTextFieldOnShow()
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
			name:.UIKeyboardWillShow,
			object: nil);
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(AddWordViewController.keyboardWillHide(notification:)),
			name:.UIKeyboardWillHide,
			object: nil);
	}

	@objc func keyboardWillShow(notification: Notification)
	{
		let info = notification.userInfo!
		let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
		additionalSafeAreaInsets.bottom = keyboardSize

		let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
	}

	@objc func keyboardWillHide(notification: Notification)
	{
		let info = notification.userInfo!
		additionalSafeAreaInsets.bottom = 0

		let duration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
	}
}

//MARK:- IBAction(s)
extension AddWordViewController {
  @IBAction func speakButton(_ sender: UIButton)
  {
    let pronouncer = WordPronouncer()
    pronouncer.pronounce(textField.text!)
  }
}

// MARK:- Show keyboard on launch
extension AddWordViewController
{
	func showKeyboardOnLaunch()
	{
		textField.becomeFirstResponder()
	}
}

extension AddWordViewController
{
  func hideTextFieldOnShow()
  {
    var visible = false
    guard let text = textField.text else { speakWordButton.animate(visible: visible); return }
    visible = (text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0) ? true : false
    speakWordButton.animate(visible: visible)
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
		// Search the dictionary
		if let word = textField.text.map(Word.init).filter(showDefinition)
		{
			// Add word to list of words
			words.add(word: word)
			
			// Clear the text field when word is successfully found
			textField.text = nil
		}
		return true
	}
}

// MARK:- Text field observation
extension AddWordViewController
{
  private func observeTextField()
  {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleTextFieldChange(_:)),
                                           name: .UITextFieldTextDidChange,
                                           object: textField)
  }
  
  @objc func handleTextFieldChange(_ notification: Notification)
  {
    guard let textField = notification.object as? UITextField else { return }
    guard let text = textField.text else { return }
    speakWordButton.animate(visible: (text.count > 0))
  }
}
