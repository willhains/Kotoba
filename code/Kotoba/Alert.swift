import Foundation
import SwiftUI

extension View {

    /// A helper that allows us to bind a SwiftUI alert to an optional object (such as a Swift enum). This is a much nicer
    /// API, and matches a similar binding for sheets.
    /// - Parameters:
    ///   - item: The item to bind to the alert. When `item` is `nil`, the alert will not show. Otherwise,
    ///     the item will be unwrapped and used in the other parameters to provide the contents of the alert.
    ///   - title: A closure that provides the title of the alert given the unwrapped item.
    ///   - actions: A view builder used to provide the actions of the alert given the unwrapped item.
    ///   - message: A view builder used to provide the message of the alert given the unwrapped item.
    func alert<Item, A: View, M: View>(
        item: Binding<Item?>,
        title: (Item) -> Text,
        @ViewBuilder actions: (Item) -> A,
        @ViewBuilder message: (Item) -> M
    ) -> some View {
        alert(
            item.wrappedValue.map(title) ?? Text(verbatim: ""),
            isPresented: Binding {
                item.wrappedValue != nil
            } set: { newValue, _ in
                if newValue == false {
                    item.wrappedValue = nil
                }
            },
            presenting: item.wrappedValue,
            actions: actions,
            message: message
        )
    }
}
