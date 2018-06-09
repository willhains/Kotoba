//
//  UIViewController+Dictionary.swift
//  Kotoba
//
//  Created by Will Hains on 2016-06-20.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
	/// Present the system dictionary as a modal view, showing the definition of `word`.
	/// - returns: `true` if the system dictionary found a definition, `false` otherwise.
	func showDefinition(forWord word: Word) -> Bool
	{
		let dictionaryViewController = UIReferenceLibraryViewController(term: word.text)
		present(dictionaryViewController, animated: true, completion: nil)
		
		// Prompt the user to set up their iOS dictionaries, the first time they use this only
		if prefs.shouldDisplayFirstUseDictionaryPrompt()
		{
			let alert = UIAlertController(
				title: "Add Dictionaries",
				message: """
                    Have you set up your iOS dictionaries?
                    Tap "Manage" below to download dictionaries for the languages you want.
                    """,
				preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Got It", style: .default, handler: nil))
			dictionaryViewController.present(alert, animated: true, completion: nil)
			
			// Update preferences to silence this prompt next time
			prefs.didDisplayFirstUseDictionaryPrompt()
		}
		
		// Return whether definition for word was found
		return UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.text)
	}
}
