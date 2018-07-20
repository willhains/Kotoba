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
  
  func allWords() -> [String]
  {
    return _words
  }
}

/// The word list model for current user.
let words: WordList = UserDefaults.standard
