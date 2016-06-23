//
//  Preferences.swift
//  Kotoba
//
//  Created by Will Hains on 2016-06-10.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation

protocol Preferences
{
	func shouldDisplayFirstUseDictionaryPrompt() -> Bool
	func didDisplayFirstUseDictionaryPrompt()
}

private let _DICTIONARY_PROMPT_DISPLAYED = "firstUseDictionaryPromptDisplayed"

extension NSUserDefaults: Preferences
{
	func shouldDisplayFirstUseDictionaryPrompt() -> Bool
	{
		return !boolForKey(_DICTIONARY_PROMPT_DISPLAYED)
	}
	
	func didDisplayFirstUseDictionaryPrompt()
	{
		setBool(true, forKey: _DICTIONARY_PROMPT_DISPLAYED)
	}
}

let prefs: Preferences = NSUserDefaults.standardUserDefaults()
