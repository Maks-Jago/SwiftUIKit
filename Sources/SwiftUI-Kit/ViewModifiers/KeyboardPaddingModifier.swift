//
//  KeyboardPaddingModifier.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 08.07.2025.
//

import SwiftUI
import Combine

public extension View {
    /// Adds bottom padding equal to the height of the keyboard whenever it's shown.
    /// - Parameter keyboardHeight: A binding to store the current height of the keyboard.
    /// - Returns: A view that adjusts its bottom padding based on the keyboard's visibility.
    func keyboardBottomPadding(keyboardHeight: Binding<CGFloat>) -> some View {
        ModifiedContent(content: self, modifier: KeyboardPaddingModifier(keyboardHeight: keyboardHeight))
    }
}

private struct KeyboardPaddingModifier: ViewModifier {
    @Binding var keyboardHeight: CGFloat

    /// Publishes keyboard height changes by observing system keyboard show/hide notifications.
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            // When keyboard will show, extract its final frame height.
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                .map(\.height),

            // When keyboard will hide, emit height as zero.
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        // Debounce to avoid rapid changes and animation conflicts.
        .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { height in
                withAnimation {
                    self.keyboardHeight = height
                }
            }
    }
}
