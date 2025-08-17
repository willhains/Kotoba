import Foundation
import UIKit

/// A simple protocol representing how we use UIPasteboard.
protocol Pasteboard
{
	var strings: [String] { get }
}

/// A real implementation of a `Pasteboard` backed by a `UIPasteboard`.
class RealPasteboard: Pasteboard
{
	let pasteboard: UIPasteboard

	init(pasteboard: UIPasteboard)
	{
		self.pasteboard = pasteboard
	}

	var strings: [String]
	{
		guard pasteboard.hasStrings else { return [] }
		return pasteboard.strings ?? []
	}
}

/// A fake implementation of a `Pasteboard` for use in tests and playgrounds.
class FakePasteboard: Pasteboard
{
	var strings: [String]

	init(strings: [String] = [])
	{
		self.strings = strings
	}
}
