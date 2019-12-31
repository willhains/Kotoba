//
//  PasteboardWordList.swift
//  Kotoba
//
//  Created by Craig Hockenberry on 11/29/19.
//  Copyright © 2019 Will Hains. All rights reserved.
//

import UIKit

private let _IGNORE_STRING_KEY = "ignore_string"

extension UIPasteboard
{
	var ignoreSuggestions: Bool {
		get {
			if let currentString = UIPasteboard.general.string {
				let ignoreString = UserDefaults.standard.string(forKey: _IGNORE_STRING_KEY)
				if currentString != ignoreString {
					return false
				}
				else {
					return true
				}
			}
			else {
				return true
			}
		}
		set {
			if newValue == true {
				UserDefaults.standard.set(UIPasteboard.general.string, forKey: _IGNORE_STRING_KEY)
			}
			else {
				UserDefaults.standard.removeObject(forKey: _IGNORE_STRING_KEY)
			}
		}
	}
	
	var suggestedWords: [Word]
	{
		if let currentPasteboardString = UIPasteboard.general.string {
			return currentPasteboardString
				.trimmingCharacters(in: .whitespacesAndNewlines)
				.asWords()
				.removingDuplicates()
				.removingPossiblePasswords()
				.removingTrivialEnglishWords()
				.map(Word.init)
		}
		else {
			return []
		}
	}

	var lines: [String]
	{
		return string?.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.filter { !$0.isEmpty }
			.removingDuplicates()
			?? []
	}
}

private let _TRIVIAL_WORDS = Set(arrayLiteral:
	"a", "an", "the", // articles
	"for", "and", "nor", "but", "or", "so", "if", // conjunctions
	"but", "at", "by", "from", "in", "into", "of", "on", "off", "to", "with") // prepositions

extension Array where Element == String
{
	func removingDuplicates() -> Array<Element>
	{
		var result: [Element] = []
		var uniques: Set<Element> = Set()
		for element in self
		{
			if !uniques.contains(element)
			{
				uniques.insert(element)
				result.append(element)
			}
		}
		return result
	}
	
	func removingPossiblePasswords() -> Array<Element>
	{
		return self.filter
		{
			return !$0.contains { $0.isSymbol || $0.isNumber || $0.isPunctuation }
		}
	}
	
	func removingTrivialEnglishWords() -> Array<Element>
	{
		return self.filter { !_TRIVIAL_WORDS.contains($0) }
	}
}

//  Adapted from https://medium.com/@sorenlind/three-ways-to-enumerate-the-words-in-a-string-using-swift-7da5504f0062
extension String
{
	func asWords() -> [String]
	{
		var result = [String]()
		if let range = range(of: self)
		{
			self.enumerateSubstrings(in: range, options: .byWords)
			{
				(substring, _, _, _) -> () in
				result.append(substring!)
			}
		}
		return result
	}
}
