import Foundation
@testable import Kotoba
import Testing

@Suite
struct WordSuggestionsModelTests {
    var userDefaults: UserDefaults

    init() {
        userDefaults = UserDefaults(suiteName: "WordSuggestionsModelTests")!
        userDefaults.removePersistentDomain(forName: "WordSuggestionsModelTests")
    }

    @Test
    func testUpdateSuggestions() {
        let fakePasteboard = FakePasteboard(strings: ["hello", "world"])
        let model = WordSuggestionsModel(pasteboard: fakePasteboard, userDefaults: userDefaults)

        // Initial suggestions
        fakePasteboard.strings = ["hello", "world"]
        model.updateSuggestions()
        #expect(model.suggestions == ["hello", "world"].map(Word.init))
        #expect(!model.isCollapsed)

        // New suggestions
        fakePasteboard.strings = ["goodnight", "moon"]
        model.updateSuggestions()
        #expect(model.suggestions == ["goodnight", "moon"].map(Word.init))
        #expect(!model.isCollapsed)

        // Collapse
        model.toggleIsCollapsed()
        #expect(model.suggestions == ["goodnight", "moon"].map(Word.init))
        #expect(model.isCollapsed)

        // Same suggestions does not uncollapse
        model.updateSuggestions()
        #expect(model.suggestions == ["goodnight", "moon"].map(Word.init))
        #expect(model.isCollapsed)

        // New suggestions uncollapses
        fakePasteboard.strings = ["vesper", "martini"]
        model.updateSuggestions()
        #expect(model.suggestions == ["vesper", "martini"].map(Word.init))
        #expect(!model.isCollapsed)
    }
}
