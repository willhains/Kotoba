//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation

struct Word
{
	let text: String
}

private let _WORD_LIST_KEY = "words"

final class WordList
{
	private let _defaults = NSUserDefaults.standardUserDefaults()
	
	private var _words: [String]
	{
		get { return _defaults.objectForKey(_WORD_LIST_KEY) as? [String] ?? [] }
		set(words) { _defaults.setObject(words, forKey: _WORD_LIST_KEY) }
	}
	
	subscript(index: Int) -> Word
	{
		get { return Word(text: _words[index]) }
	}
	
	var count: Int { return _words.count }
	
	func addWord(word: Word)
	{
		var words = _words
		let lowercase = word.text.lowercaseString
		if let existingIndex = words.indexOf(lowercase)
		{
			words.removeAtIndex(existingIndex)
		}
		words.insert(lowercase, atIndex: 0)
		_words = words
	}
	
	func deleteWord(atIndex index: Int)
	{
		var words = _words
		words.removeAtIndex(index)
		_words = words
	}
}
