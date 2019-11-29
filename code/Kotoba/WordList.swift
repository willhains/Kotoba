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
	
	// TODO #14: This is where metadata would go.
	
	func canonicalise() -> String
	{
		return self.text.lowercased()
	}
}

/// Choices for where to store the word list.
enum WordListStore
{
	case local
	case iCloud
}

/// Model of user's saved words.
protocol WordListDataSource
{
	/// Access saved words by index.
	subscript(index: Int) -> Word { get }
	
	/// The number of saved words.
	var count: Int { get }
	
	/// Add `word` to the word list.
	mutating func add(word: Word)
	
	/// Delete the word at `index` from the word list.
	mutating func delete(wordAt index: Int)
	
	/// Delete all words from the word list.
	mutating func clear()
	
	/// Merge all words from `another` into self, avoiding duplicates.
	mutating func merge(from source: WordListDataSource)
	
	/// Replace all words in self with words from `another`.
	mutating func replace(with source: WordListDataSource)
	
	/// All words, delimited by newlines
	func asText() -> String
}

protocol WordListStrings
{
	var wordStrings: [String] { get set }
}

// Default implementations
extension WordListDataSource where Self: WordListStrings
{
	subscript(index: Int) -> Word
	{
		get { return Word(text: wordStrings[index]) }
		set(newWord) { wordStrings[index] = newWord.text }
	}
	
	var count: Int
	{
		return wordStrings.count
	}
	
	mutating func add(word: Word)
	{
		// Prevent duplicates; move to top of list instead
		wordStrings.add(possibleDuplicate: word.canonicalise())
	}
	
	mutating func delete(wordAt index: Int)
	{
		wordStrings.remove(at: index)
	}
	
	mutating func clear()
	{
		wordStrings = []
	}
	
	mutating func merge(from source: WordListDataSource)
	{
		for i in 0..<source.count
		{
			add(word: source[i])
		}
	}

/* 
	subscript(index: Int) -> Word
	{
		get {
			let text = _words[index]
			let word = UserDefaults.standard.CHOCKTUBA_DUH ? Word(text: text.uppercased()) : Word(text: text)
			return word
			
		}
	}
	
	var count: Int { return _words.count }
 */
	
	mutating func replace(with source: WordListDataSource)
	{
		clear()
		merge(from: source)
	}
	
	func asText() -> String
	{
		return wordStrings.joined(separator: "\n")
	}
}

// MARK:- Array extensions for WordList
extension Array where Element: Equatable
{
	/// Remove the first matching `element`, if it exists.
	mutating func remove(_ element: Element)
	{
		if let existingIndex = firstIndex(of: element)
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

// MARK:- WordList implementation backed by UserDefaults / NSUbiquitousKeyValueStore

private let _WORD_LIST_KEY = "words"
private let _USE_REMOTE_KEY = "use_icloud"

var wordListStore: WordListStore
{
	get { UserDefaults.standard.bool(forKey: _USE_REMOTE_KEY) ? .iCloud : .local }
	set { UserDefaults.standard.set(newValue == .iCloud, forKey: _USE_REMOTE_KEY) }
}

extension UserDefaults: WordListStrings, WordListDataSource
{
	var wordStrings: [String]
	{
		get { return object(forKey: _WORD_LIST_KEY) as? [String] ?? [] }
		set(words) { set(words, forKey: _WORD_LIST_KEY) }
	}
}

extension NSUbiquitousKeyValueStore: WordListStrings, WordListDataSource
{
	var wordStrings: [String]
	{
		get { return object(forKey: _WORD_LIST_KEY) as? [String] ?? [] }
		set(words) { NSUbiquitousKeyValueStore.default.set(words, forKey: _WORD_LIST_KEY) }
	}
}

let dataSourceLocal: WordListDataSource = UserDefaults.standard
let dataSourceCloud: WordListDataSource = NSUbiquitousKeyValueStore.default

//class WordList
//{
//	class var useRemote: Bool
//	{
//		get
//		{
//			return UserDefaults.standard.bool(forKey: _USE_REMOTE_KEY)
//		}
//		set
//		{
//			UserDefaults.standard.set(newValue, forKey: _USE_REMOTE_KEY)
//			UserDefaults.standard.synchronize()
//		}
//	}
//
//	class var hasLocalData: Bool
//	{
//		return (UserDefaults.standard.object(forKey: _WORD_LIST_KEY) as? [String]) != nil
//	}
//
//	class var hasRemoteData: Bool
//	{
//		return (NSUbiquitousKeyValueStore.default.object(forKey: _WORD_LIST_KEY) as? [String]) != nil
//	}
//
//	var local: Bool
//
//	init(local: Bool = true)
//	{
//		self.local = local
//	}
//
//	fileprivate var _words: [String]
//	{
//		get
//		{
//			if local
//			{
//				return UserDefaults.standard.object(forKey: _WORD_LIST_KEY) as? [String] ?? []
//			}
//			else
//			{
//				return NSUbiquitousKeyValueStore.default.object(forKey: _WORD_LIST_KEY) as? [String] ?? []
//			}
//
//		}
//		set(words)
//		{
//			if local
//			{
//				UserDefaults.standard.set(words, forKey: _WORD_LIST_KEY)
//			}
//			else
//			{
//				NSUbiquitousKeyValueStore.default.set(words, forKey: _WORD_LIST_KEY)
//			}
//		}
//	}
//
//	func remove()
//	{
//		if local
//		{
//			UserDefaults.standard.removeObject(forKey: _WORD_LIST_KEY)
//		}
//		else
//		{
//			NSUbiquitousKeyValueStore.default.removeObject(forKey: _WORD_LIST_KEY)
//		}
//	}
//
//	subscript(index: Int) -> Word
//	{
//		get { return Word(text: _words[index]) }
//	}
//
//	var count: Int { return _words.count }
//
//	func add(word: Word)
//	{
//		var words = _words
//		let lowercase = word.text.lowercased()
//
//		// Prevent duplicates; move to top of list instead
//		words.add(possibleDuplicate: lowercase)
//
//		_words = words
//	}
//
//	func delete(wordAt index: Int)
//	{
//		var words = _words
//		words.remove(at: index)
//		_words = words
//	}
//
//	func clear()
//	{
//		_words = []
//	}
//}

/// The word list model for current user.
var words: WordListDataSource
{
	get { wordListStore == .local ? dataSourceLocal : dataSourceCloud }
	set {}
}
