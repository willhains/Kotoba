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
	private static let QUOTES = CharacterSet(charactersIn: "\"'“”‘’")

	let text: String

	init(text: String)
	{
		self.text = text
			.lowercased()
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.trimmingCharacters(in: Word.QUOTES)
	}

	// TODO #14: This is where metadata would go.
}
