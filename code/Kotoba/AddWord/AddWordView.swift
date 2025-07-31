import Foundation
import SwiftUI
import UIKit

/// The main view of the app, consisting of a text field for looking up a word, as well as a list
/// of suggested words pulled from the pasteboard.
struct AddWordView: View {

    /// Alerts that are allowed to be displayed by this view.
    enum Alert: Identifiable {
        case chocktuba(enabled: Bool)

        var id: String {
            switch self {
            case .chocktuba(let enabled): "chocktuba:\(enabled)"
            }
        }
    }

    /// Sheets that are allowed to be displayed by this view.
    enum Sheet: Identifiable {
        case dictionary(term: Word)
        case settings
        case wordList

        var id: String {
            switch self {
            case .dictionary(let term): "dictionary:" + term.text
            case .settings: "settings"
            case .wordList: "wordList"
            }
        }
    }

    @FocusState private var isTextFieldFocused: Bool
    @State private var alert: Alert?
    @State private var isSearching: Bool = false
    @State private var sheet: Sheet?
    @State private var typedWord: String = ""
    @State private var wordSuggestionsModel: WordSuggestionsModel

    @Environment(\.chocktubaEnabled) var chocktubaEnabled

    init(wordSuggestionsModel: WordSuggestionsModel) {
        self.wordSuggestionsModel = wordSuggestionsModel
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                TextField("ADD_WORD_LOOKUP_PLACEHOLDER", text: $typedWord)
                    .minimumScaleFactor(0.5)
                    .textInputAutocapitalization(chocktubaEnabled ? .characters : .never)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        if typedWord.trimmingCharacters(in: .whitespacesAndNewlines) == Chocktuba.activationPhrase {
                            toggleChocktuba()
                        } else {
                            lookupWord(term: Word(text: typedWord))
                        }
                    }
                    .font(.custom("AmericanTypewriter", size: 42))
                    .multilineTextAlignment(.center)
                    .padding()

                ProgressView()
                    .opacity(isSearching ? 1.0 : 0.0)

                Spacer()

                WordSuggestionsView(
                    model: wordSuggestionsModel,
                    onTapSuggestion: { term in
                        lookupWord(term: term)
                    }
                )
            }
            .background(Color(UIColor.systemGray6))
            .navigationTitle("APP_NAVIGATION_TITLE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { sheet = .settings }) {
                        Image(systemName: "gear")
                    }
                    .accessibilityLabel("ADD_WORD_SETTINGS_ACCESSIBILITY_LABEL")
                    .tint(Color("appBarItemTint"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { sheet = .wordList }) {
                        Image(systemName: "book")
                    }
                    .accessibilityLabel("ADD_WORD_HISTORY_ACCESSIBILITY_LABEL")
                    .tint(Color("appBarItemTint"))
                }
                ToolbarItem(placement: .principal) {
                    Text("APP_NAVIGATION_TITLE")
                        .font(.custom("AmericanTypewriter-Semibold", size: 20))
                }
            }
        }
        .disabled(isSearching)
        .onAppear {
            wordSuggestionsModel.updateSuggestions()
            isTextFieldFocused = true
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didBecomeActiveNotification
            )
        ) { _ in
            withAnimation {
                wordSuggestionsModel.updateSuggestions()
            }
        }
        .sheet(item: $sheet) { sheet in
            switch sheet {
            case .dictionary(let term):
                DictionaryView(term: term.text)
                    .onAppear {
                        isSearching = false

                        let hasDefinition = UIReferenceLibraryViewController.dictionaryHasDefinition(
                            forTerm: term.text
                        )

                        if hasDefinition {
                            var words = wordListStore.data
                            words.add(word: term)
                            typedWord = ""
                        }
                    }
                    .onDisappear {
                        isTextFieldFocused = true
                    }
            case .settings:
                SettingsView()
            case .wordList:
                WordListView()
            }
        }
        .alert(
            item: $alert,
            title: { item in
                switch item {
                case .chocktuba(let enabled):
                    Text("CHOCKTUBA \(enabled ? "ON" : "OFF")")
                }
            },
            actions: { item in
                Button("CTL ALT DEL TO RESTART") {
                    exit(0)
                }
            }, message: { item in
                switch item {
                case .chocktuba(let enabled):
                    if enabled {
                        Text("YOU JUST MADE THIS APP A BILLION TIMES BETTER CONGRATS")
                    } else {
                        Text("WHAT THE HELL ARE YOU THINKING")
                    }
                }
            }
        )
        .tint(Color("appTint"))
    }

    private func lookupWord(term: Word) {
        typedWord = term.text

        // NOTE: On iOS 13, UIReferenceLibraryViewController got slow, both to return a view controller
        // and do a definition lookup. Previously, Kotoba did both these things at the same time on
        // the same queue.
        //
        // We use the `isSearching` variable to show a progress indicator to indicate that the app is
        // doing something while it attempts to show the dictionary. We unfortunately can not ask
        // UIReferenceLibraryViewController to do the heavy lifting on a background thread as it is
        // annotated with `MainActor`.
        isSearching = true

        sheet = .dictionary(term: term)
    }

    private func toggleChocktuba() {
        alert = .chocktuba(enabled: !Chocktuba.isEnabled)
        Chocktuba.toggle()
    }
}

#Preview("Empty") {
    AddWordView(
        wordSuggestionsModel: WordSuggestionsModel(
            pasteboard: FakePasteboard(strings: [])
        )
    )
}

#Preview("Suggestions") {
    AddWordView(
        wordSuggestionsModel: WordSuggestionsModel(
            pasteboard: FakePasteboard(
                strings: [
                    "baccarat",
                    "sharks",
                    "vesper",
                ]
            )
        )
    )
}
