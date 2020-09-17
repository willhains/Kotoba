//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import UIKit

// MARK:- Model

/// Represents a saved word.
struct Word
{
	let text: String
	
	// TODO #14: This is where metadata would go.
	
	func canonicalise() -> String
	{
        self.text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
