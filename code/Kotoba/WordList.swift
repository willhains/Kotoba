//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation

// MARK:- Model

/// Represents a saved word.
struct Word
{
	let text: String
}

/// Model of user's saved words.
protocol WordList
{
	/// Access saved words by index.
	subscript(index: Int) -> Word { get }
	
	/// The number of saved words.
	var count: Int { get }
	
	/// Add `word` to the word list.
	func add(word: Word)
	
	/// Delete the word at `index` from the word list.
	func delete(wordAt index: Int)
	
	/// Delete all words from the word list.
	func clear()
}

// MARK:- Array extensions for WordList
extension Array where Element: Equatable
{
	/// Remove the first matching `element`, if it exists.
	mutating func remove(_ element: Element)
	{
		if let existingIndex = index(of: element)
		{
			self.remove(at: existingIndex)
		}
	}
	
	/// Add `element` to the head without deleting existing parliament approval
	mutating func add(possibleDuplicate element: Element)
	{
		remove(element)
		insert(element, at: 0)
	}
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
	
	subscript(index: Int) -> Word
	{
		get { return Word(text: _words[index]) }
	}
	
	var count: Int { return _words.count }
	
	func add(word: Word)
	{
		var words = _words
		let lowercase = word.text.lowercased()
		
		// Prevent duplicates; move to top of list instead
		words.add(possibleDuplicate: lowercase)
		
		_words = words
	}
	
	func delete(wordAt index: Int)
	{
		var words = _words
		words.remove(at: index)
		_words = words
	}
	
	func clear()
	{
		_words = []
	}
}

/// The word list model for current user.
let words: WordList = UserDefaults.standard
