//
//  KeyboardVisibility.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import Combine
import SwiftUI

/// A view modifier that monitors the keyboard's visibility state and passes it to the SwiftUI environment.
/// The `KeyboardVisibility` modifier allows you to observe whether the keyboard is shown or hidden and adjust your UI accordingly.
///
/// This modifier listens for keyboard show and hide notifications and updates an `isKeyboardShowing` property, which is passed to the
/// SwiftUI environment.
///
/// Example usage:
/// ```swift
/// struct ContentView: View {
///     @Environment(\.keyboardShowing) var isKeyboardShowing
///
///     var body: some View {
///         VStack {
///             Text("Keyboard is \(isKeyboardShowing ? "visible" : "hidden")")
///             TextField("Type something", text: .constant(""))
///                 .textFieldStyle(RoundedBorderTextFieldStyle())
///                 .padding()
///         }
///         .modifier(KeyboardVisibility())
///     }
/// }
/// ```
///
/// - `KeyboardVisibility` updates the environment key `keyboardShowing` with the current keyboard visibility status.
@available(iOS 14.0, *)
struct KeyboardVisibility: ViewModifier {
    @StateObject private var keyboardMonitor = KeyboardMonitor()

    /// Monitors the keyboard visibility state and injects it into the environment.
    func body(content: Content) -> some View {
        content.environment(\.keyboardShowing, keyboardMonitor.isKeyboardShowing)
    }
}

private final class KeyboardMonitor: ObservableObject {
    @Published var isKeyboardShowing: Bool = false
    private var cancellables = Set<AnyCancellable>()

    /// Initializes the monitor by subscribing to keyboard show/hide notifications.
    init() {
        // Subscribe to the keyboardWillShow notification and update isKeyboardShowing to true
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .assign(to: \.isKeyboardShowing, on: self)
            .store(in: &cancellables)

        // Subscribe to the keyboardWillHide notification and update isKeyboardShowing to false
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
            .assign(to: \.isKeyboardShowing, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - keyboardShowing
private struct KeyboardShowingEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

public extension EnvironmentValues {
    var keyboardShowing: Bool {
        get { self[KeyboardShowingEnvironmentKey.self] }
        set { self[KeyboardShowingEnvironmentKey.self] = newValue }
    }
}

// MARK: - addKeyboardVisibilityToEnvironment
public extension View {
    @available(iOS 14.0, *)
    func addKeyboardVisibilityToEnvironment() -> some View {
        modifier(KeyboardVisibility())
    }
}
