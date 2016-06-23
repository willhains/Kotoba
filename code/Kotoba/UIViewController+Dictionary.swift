//
//  UIViewController+Dictionary.swift
//  Kotoba
//
//  Created by Will Hains on 2016-06-20.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Reference Library
extension UIViewController
{
	func showDefinitionForWord(word: Word) -> Bool
	{
		let refVC = UIReferenceLibraryViewController(term: word.text)
		presentViewController(refVC, animated: true, completion: nil)
		
		// Prompt the user to set up their iOS dictionaries
		if prefs.shouldDisplayFirstUseDictionaryPrompt()
		{
			let alert = UIAlertController(
				title: "Add Dictionaries",
				message: "Have you set up your iOS dictionaries?\n"
					+ "Tap \"Manage\" below to download dictionaries for the languages you want.",
				preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "Got It", style: .Default, handler: nil))
			refVC.presentViewController(alert, animated: true, completion: nil)
			
			prefs.didDisplayFirstUseDictionaryPrompt()
		}
		
		// Return whether definition for word was found
		return UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(word.text)
	}
}
