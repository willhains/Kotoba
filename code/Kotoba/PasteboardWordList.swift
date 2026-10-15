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
}
