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
	func showDefinition(forWord word: Word, completion: (() -> Void)? = nil)
	{
		let dictionaryViewController = UIReferenceLibraryViewController(term: word.text)
		self.present(dictionaryViewController, animated: true, completion: completion)
		
		// Prompt the user to set up their iOS dictionaries, the first time they use this only
		if prefs.shouldDisplayFirstUseDictionaryPrompt()
		{
			debugLog("First-time lookup. Let's see if the user has dictionaries set up...")
			if !UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: "OK")
			{
				debugLog("No dictionaries set up. Prompting user.")
				let alert = UIAlertController(
					title: "Add Dictionaries",
					message: """
						Have you set up your iOS dictionaries?
						Tap "Manage" below to download dictionaries for the languages you want.
						""",
					preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Got It", style: .default, handler: nil))
				dictionaryViewController.present(alert, animated: true, completion: nil)
			}
			
			// Update preferences to silence this prompt next time
			prefs.didDisplayFirstUseDictionaryPrompt()
		}
	}
}
