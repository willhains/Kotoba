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
		// TODO: Filter out too-simple words ("to", "and", "of", etc.).
		// TODO: Filter out non-words and likely passwords (digits, symbols).

		#warning("Remove this test data")
		//return []
		//return [ Word(text: "CHOCKTUBA")]
		//return [ Word(text: "CHOCKTUBA"), Word(text: "ROCKS")]
		//return [ Word(text: "CHOCKTUBA"), Word(text: "ROCKS"), Word(text: "FOO")]
		//return [ Word(text: "CHOCKTUBA"), Word(text: "Rocks"), Word(text: "foo"), Word(text: "bar")]

		if let currentPasteboardString = UIPasteboard.general.string {
			return currentPasteboardString
				.trimmingCharacters(in: .whitespacesAndNewlines)
				.words
				.removingDuplicates()
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

extension Array where Element: Hashable
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
}

//  Adapted from https://medium.com/@sorenlind/three-ways-to-enumerate-the-words-in-a-string-using-swift-7da5504f0062
extension String
{
	var words: [String]
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
