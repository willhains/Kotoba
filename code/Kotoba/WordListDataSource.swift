//
// Created by Will Hains on 2020-06-21.
// Copyright (c) 2020 Will Hains. All rights reserved.
//

import Foundation

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

	/// Latest word
	var latestWord: Word? { get }
}

// Default implementations
extension WordListDataSource where Self: WordListStrings
{
	subscript(index: Int) -> Word
	{
		get { Word(text: wordStrings[index]) }
		set { wordStrings[index] = newValue.text }
	}

	var count: Int { wordStrings.count }

	mutating func add(word: Word)
	{
		// Prevent duplicates; move to top of list instead
		wordStrings.add(possibleDuplicate: word.text)
		debugLog("add: wordStrings=\(wordStrings.first ?? "")..\(wordStrings.last ?? "")")
	}

	mutating func delete(wordAt index: Int)
	{
		wordStrings.remove(at: index)
		debugLog("remove: wordStrings=\(wordStrings.first ?? "")..\(wordStrings.last ?? "")")
	}

	mutating func clear()
	{
		wordStrings = []
	}

	func asText() -> String
	{
		// NOTE: Adding a newline at the end makes it easier to edit in a text editor like Notes.
		// It also conforms to the POSIX standard.
		// https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline#729795
		wordStrings.joined(separator: "\n") + "\n"
	}

	var latestWord: Word? { wordStrings.first.map(Word.init) }
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

	/// Add `element` to the head without duplicating existing
	mutating func add(possibleDuplicate element: Element)
	{
		remove(element)
		insert(element, at: 0)
	}
}

// MARK:- WordListDataSource implementation backed by UserDefaults / NSUbiquitousKeyValueStore

private let _WORD_LIST_KEY = "words"

extension NSUbiquitousKeyValueStore: WordListStrings, WordListDataSource
{
	var wordStrings: [String]
	{
		get { object(forKey: _WORD_LIST_KEY) as? [String] ?? [] }
		set { NSUbiquitousKeyValueStore.default.set(newValue, forKey: _WORD_LIST_KEY) }
	}
	
	static var iCloudEnabledInSettings: Bool { FileManager.default.ubiquityIdentityToken != nil }
}
