//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation

/// Model of user's saved words.
protocol WordList
{
	/// The number of saved words.
	var count: Int { get }
	
	/// Delete all words from the word list.
	func clear()
	
	/// Returns an `Array` of all the words in the database
	func allWords() -> [String]
}

// MARK:- WordList implementation backed by NSUserDefaults

private let _WORD_LIST_KEY = "words"

extension UserDefaults: WordList
{
	// Read/write an array of Strings to represent word list
	fileprivate var _words: [String]
	{
		get { return object(forKey: _WORD_LIST_KEY) as? [String] ?? [] }
		set(words) { set(words, forKey: _WORD_LIST_KEY) }
	}
	
	var count: Int { return _words.count }
	
	func clear()
	{
		_words = []
	}
	
	// WH: You deleted the `Word` struct, saying it is redundant, but I don't think so. I much prefer to wrap value types, especially for `String`, to avoid the so-called "stringly-typed" problem. Wrapping value types has many benefits -- they can have meaningful, domain-oriented names; their initialisers can enforce validation rules on the content; and the API can be restricted and extended in domain-aware ways. `String` is the worst offender, since it can contain almost literally any data, and there are always so many strings flying all over the place. Wrapping strings in custom value types gives type safety; `String` is effectively type-unsafe.
	func allWords() -> [String]
	{
		return _words
	}
}

// WH: Let's rename this to make it clearer that it's legacy, for first-time upgrade to CoreData only. Or at least name it something that indicates its relationship to UserDefaults.
/// The word list model for current user.
let words: WordList = UserDefaults.standard
