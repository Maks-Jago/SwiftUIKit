//
//  TextOverflowingModifier.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 07.07.2025.
//

import SwiftUI

/// A view modifier that determines whether a given text string would overflow its available vertical space.
///
/// This modifier uses `ViewThatFits` to compare the layout behavior of the provided text. If the `Text` fits, it triggers the
/// `completion` handler with `false`, otherwise with `true`, allowing developers to react to overflow cases (e.g., show a "read more").
///
/// - Note: The modifier uses hidden views and does not alter layout or appearance of the content it is applied to.
/// ### Example:
/// ```
/// Text(description)
///     .lineLimit(n)
///     .textOverflowing(description, font: .font()) {
///         if !isDescriptionOverflowing {
///             isDescriptionOverflowing = $0
///         }
///     }
/// ```
@available(iOS 16.0, *)
public struct TextOverflowingModifier: ViewModifier {
    private let text: String
    private let font: Font
    private let completion: (Bool) -> Void

    /// Initializes a `TextOverflowingModifier`.
    ///
    /// - Parameters:
    ///   - text: The text string to test for overflow.
    ///   - font: The font used for rendering the text.
    ///   - completion: A closure that receives a boolean indicating overflow state.
    public init(text: String, font: Font, completion: @escaping (Bool) -> Void) {
        self.text = text
        self.font = font
        self.completion = completion
    }

    public func body(content: Content) -> some View {
        content
            .background(
                ViewThatFits(in: .vertical) {
                    Text(text)
                        .hidden()
                        .font(font)
                        .onAppear {
                            completion(false)
                        }

                    Color.clear
                        .hidden()
                        .onAppear {
                            completion(true)
                        }
                }
            )
    }
}

/// An extension on `View` to easily check if a given text overflows the view vertically.
///
/// This method applies `TextOverflowingModifier` and calls the completion handler when
/// layout is resolved. The handler indicates whether the given text exceeds the space.
///
/// - Parameters:
///   - text: The text to check.
///   - font: The font used to render the text.
///   - completion: A closure that receives `true` if the text overflows; otherwise, `false`.
///
/// - Returns: A modified view that performs overflow detection.
@available(iOS 16.0, *)
public extension View {
    func textOverflowing(
        _ text: String,
        font: Font,
        completion: @escaping (Bool) -> Void
    ) -> some View {
        modifier(
            TextOverflowingModifier(
                text: text,
                font: font,
                completion: completion
            )
        )
    }
}
