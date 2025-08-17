import Foundation
import SwiftUI

/// A list of suggested words to display to the user, sourced from the pasteboard.
struct WordSuggestionsView: View {
    @Bindable private var model: WordSuggestionsModel
    let onTapSuggestion: (Word) -> Void

    /// Used to calculate and hold onto the content height of the list. This can then
    /// be used to constrain the height of the list if the contents are sufficiently small.
    @State var contentHeight: CGFloat = 0.0

    @Environment(\.chocktubaEnabled) var chocktubaEnabled

    init(
        model: WordSuggestionsModel,
        onTapSuggestion: @escaping (Word) -> Void
    ) {
        self.model = model
        self.onTapSuggestion = onTapSuggestion
    }

    var body: some View {
        VStack(spacing: 0) {
            Button(
                action: {
                    withAnimation {
                        model.toggleIsCollapsed()
                    }
                }
            ) {
                HStack {
                    Text("ADD_WORD_LOOKUP_SUGGESTIONS_HEADER")
                        .font(.headline)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(model.isCollapsed ? 0 : 90))
                }
                .padding()
                .background(Color.gray.opacity(0.3))
            }
            .buttonStyle(.plain)

            if !model.isCollapsed {
                List {
                    ForEach(model.suggestions, id: \.self) { suggestion in
                        Button(action: {
                            onTapSuggestion(suggestion)
                        }) {
                            Text(
                                chocktubaEnabled ? suggestion.text.uppercased() : suggestion.text
                            )
                        }
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { geometry in
                    geometry.contentSize.height
                } action: { _, newValue in
                    contentHeight = newValue
                }
                .listStyle(.plain)
                .frame(maxHeight: min(contentHeight, 160))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .ignoresSafeArea()
        .background(Color(UIColor.systemBackground))
    }
}
