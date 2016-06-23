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

protocol WordList
{
	subscript(index: Int) -> Word { get }
	var count: Int { get }
	func addWord(word: Word)
	func deleteWord(atIndex index: Int)
}

extension Array where Element: Equatable
{
	mutating func remove(element: Element)
	{
		if let existingIndex = indexOf(element)
		{
			removeAtIndex(existingIndex)
		}
	}
}

private let _WORD_LIST_KEY = "words"

extension NSUserDefaults: WordList
{
	private var _words: [String]
	{
		get { return objectForKey(_WORD_LIST_KEY) as? [String] ?? [] }
		set(words) { setObject(words, forKey: _WORD_LIST_KEY) }
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
		words.remove(lowercase)
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

let words: WordList = NSUserDefaults.standardUserDefaults()
