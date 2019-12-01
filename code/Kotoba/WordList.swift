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
	
	var data: WordListDataSource
	{
		switch self
		{
			case .local: return UserDefaults.standard
			case .iCloud: return NSUbiquitousKeyValueStore.default
		}
	}
}

/// Current selection of word list store.
var wordListStore: WordListStore
{
	get { prefs.iCloudSyncEnabled ? .iCloud : .local }

	set
	{
		prefs.iCloudSyncEnabled = newValue == .iCloud
		
		// Merge word lists
		var local: WordListStrings = UserDefaults.standard
		var cloud: WordListStrings = NSUbiquitousKeyValueStore.default
		for word in local.wordStrings where !cloud.wordStrings.contains(word)
		{
			cloud.wordStrings.insert(word, at: 0)
		}
		local.wordStrings = cloud.wordStrings
	}
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
	
	/// All words, delimited by newlines
	func asText() -> String
}

/// Internal persistence of word list as an array of strings.
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
		set { wordStrings[index] = newValue.text }
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
	
	func asText() -> String
	{
		return wordStrings.joined(separator: "\n")
	}
}

// MARK:- Array extensions for WordList
// TODO #14: Consider changing Array to Set, and sorting by date added.
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

// MARK:- WordListDataSource implementation backed by UserDefaults / NSUbiquitousKeyValueStore

private let _WORD_LIST_KEY = "words"

extension UserDefaults: WordListStrings, WordListDataSource
{
	var wordStrings: [String]
	{
		get { return object(forKey: _WORD_LIST_KEY) as? [String] ?? [] }
		set { set(newValue, forKey: _WORD_LIST_KEY) }
	}
}

extension NSUbiquitousKeyValueStore: WordListStrings, WordListDataSource
{
	var wordStrings: [String]
	{
		get { return object(forKey: _WORD_LIST_KEY) as? [String] ?? [] }
		set { NSUbiquitousKeyValueStore.default.set(newValue, forKey: _WORD_LIST_KEY) }
	}
}
