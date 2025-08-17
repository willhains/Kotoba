//
//  Created by Craig Hockenberry on 11/29/19.
//  Copyright © 2019 Will Hains. All rights reserved.
//

import UIKit

extension UIPasteboard
{
	var lines: [String]
	{
		string?.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .whitespaces) }
			.filter { !$0.isEmpty }
			.removingDuplicates()
			?? []
	}
}

private let _TRIVIAL_WORDS = Set(
	arrayLiteral:
	"a", "an", "the", // articles
	"for", "and", "nor", "but", "or", "so", "if", // conjunctions
	"but", "at", "by", "from", "in", "into", "of", "on", "off", "to", "with") // prepositions

extension Array where Element == String
{
    func processWords() -> [Word] {
        self
            .flatMap { $0.asWords() }
            .map {
                $0
                    .lowercased()
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: Word.QUOTES)
            }
            .removingDuplicates()
            .removingPossiblePasswords()
            .removingTrivialEnglishWords()
            .map(Word.init)
    }

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
		self.filter { !$0.contains { $0.isSymbol || $0.isNumber || $0.isPunctuation } }
	}

	func removingTrivialEnglishWords() -> Array<Element>
	{
		self.filter { !_TRIVIAL_WORDS.contains($0) }
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
