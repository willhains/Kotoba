import Foundation
import SwiftUI

/// An observable model that represents the data needed to power the `WordSuggestionsView`.
@Observable
class WordSuggestionsModel
{
	private static let _IGNORE_STRING_KEY = "ignore_string"

	/// Whether or not the word suggestions table on the `AddWordView` is collapsed or expanded.
	private(set) var isCollapsed: Bool = false

	/// The list of suggestions to display in the view.
	private(set) var suggestions: [Word] = []

	@ObservationIgnored
	let pasteboard: Pasteboard

	@ObservationIgnored
	let userDefaults: UserDefaults

	init(
		pasteboard: Pasteboard,
		userDefaults: UserDefaults = .standard)
	{
		self.pasteboard = pasteboard
		self.userDefaults = userDefaults
	}

	func toggleIsCollapsed()
	{
		isCollapsed.toggle()

		if isCollapsed
		{
			/// When the user specifically wants to ignore a specific pasteboard suggestion, we store that suggestion
			/// to User Defaults, allowing us to continue to ignore it even if they relaunch the app. We are careful here
			/// to store the suggestions after they have been processed and potential passwords have been removed.
			suggestionsToIgnore = suggestions
		}
		else
		{
			suggestionsToIgnore = []
		}
	}

	private var suggestionsToIgnore: [Word]
	{
		get
		{
			userDefaults.string(forKey: Self._IGNORE_STRING_KEY)?.components(separatedBy: .newlines).map(Word.init) ?? []
		}
		set
		{
			if newValue.isEmpty
			{
				userDefaults.removeObject(forKey: Self._IGNORE_STRING_KEY)
			}
			else
			{
				userDefaults.set(newValue.map({ $0.text }).joined(separator: "\n"), forKey: Self._IGNORE_STRING_KEY)
			}
		}
	}

	/// Looks at the pasteboard for suggestions and updates them if appropriate.
	func updateSuggestions()
	{
		let strings = pasteboard.strings

		if strings.isEmpty
		{
			suggestionsToIgnore = []
			isCollapsed = false
			suggestions = []
		}
		else
		{
			suggestions = strings.processWords()
			if suggestions == suggestionsToIgnore
			{
				isCollapsed = true
			}
			else
			{
				isCollapsed = false
				suggestionsToIgnore = []
			}
		}
	}
}
