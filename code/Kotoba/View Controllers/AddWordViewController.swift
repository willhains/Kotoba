//
//  AddWordViewController.swift
//  Kotoba
//
//  Created by Will Hains on 06/17.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation // WH: Redundant import?
import UIKit

final class AddWordViewController: UIViewController
{
	@IBOutlet weak var textField: UITextField!
	var contextProvider: ContextProvider?
	
	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		prepareKeyboardAvoidance()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		showKeyboardOnLaunch()
	}
}

// MARK:- Setting ContextProvider
extension AddWordViewController: ContextProviderSettable { }

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

// MARK:- Show keyboard on launch
extension AddWordViewController
{
	func showKeyboardOnLaunch()
	{
		self.textField.becomeFirstResponder()
	}
}

// MARK:- IBAction
extension AddWordViewController
{
	@IBAction func showWordList(sender: UIBarButtonItem)
	{
		guard let provider = contextProvider else { return }
		let wordListViewController = ViewControllerFactory.newWordListViewController(contextProvider: provider)
		navigationController?.pushViewController(wordListViewController, animated: true)
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
		guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return true }
		if showDefinition(forWord: text)
		{
			DispatchQueue.global(qos: .default).async
			{
				[unowned self] in
				if let context = self.contextProvider?.backgroundContext
				{
					context.makeChanges
					{
						var word = DictionaryQuery.findOrAdd(word: text, inContext: context)
						if !word.isNewEntry
						{
							word.entryDate = Date()
						}
					}
				}
			}
			
			// Clear the text field when word is successfully found
			textField.text = nil
		}
		return true
	}
}
