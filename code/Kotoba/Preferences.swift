//
//  Preferences.swift
//  Kotoba
//
//  Created by Will Hains on 2016-06-10.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation

private let _MANAGE_DICTIONARIES_PROMPT_DISPLAYED_KEY = "manageDictionariesPromptDisplayed"

final class Preferences
{
	private let _defaults = NSUserDefaults.standardUserDefaults()
	
	func ifFirstTimeToShowReferenceLibrary(doAction action: Void -> Void)
	{
		if !_defaults.boolForKey(_MANAGE_DICTIONARIES_PROMPT_DISPLAYED_KEY)
		{
			action()
			_defaults.setBool(true, forKey: _MANAGE_DICTIONARIES_PROMPT_DISPLAYED_KEY)
		}
	}
}
