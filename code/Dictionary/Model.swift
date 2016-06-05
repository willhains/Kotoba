//
//  WordList.swift
//  Words
//
//  Created by Will Hains on 2016-06-05.
//  Copyright © 2016 Will Hains. All rights reserved.
//

import Foundation

class WordList
{
	private let _defaults = NSUserDefaults.standardUserDefaults()
	
	private var _words: [String]
	{
		get { return _defaults.objectForKey("words") as? [String] ?? [] }
		
		set(words)
		{
			_defaults.setObject(words, forKey: "words")
		}
	}
	
	subscript(index: Int) -> Word
	{
		get { return Word(text: _words[index]) }
	}
	
	var count: Int { return _words.count }
	
	func addWord(word: Word)
	{
		var words = _words
		words.insert(word.text, atIndex: 0)
		_words = words
	}
	
	func deleteWord(atIndex index: Int)
	{
		var words = _words
		words.removeAtIndex(index)
		_words = words
	}
}
