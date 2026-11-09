//===--- Common.swift --------------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

#if canImport(UIKit)
import UIKit

/// Obtains the key window of the app's UI from the application's connected scenes.
///
/// Scenes shown on an external display are skipped, so the result is always a window of the app itself.
/// If several app scenes have a key window, the one in the active scene is preferred.
/// - Returns: The current key `UIWindow` if available, or `nil` if not found.
public func obtainKeyWindow() -> UIWindow? {
    var fallbackKeyWindow: UIWindow?

    for scene in UIApplication.shared.connectedScenes {
        guard let windowScene = scene as? UIWindowScene, windowScene.session.role == .windowApplication else {
            continue
        }

        for window in windowScene.windows where window.isKeyWindow {
            if windowScene.activationState == .foregroundActive {
                return window
            }

            if fallbackKeyWindow == nil {
                fallbackKeyWindow = window
            }
        }
    }

    return fallbackKeyWindow
}

/// Hides the keyboard for the current key window, if any.
public func hideKeyboard() {
    obtainKeyWindow()?.endEditing(true)
}

/// Returns a closure that performs an action and then hides the keyboard.
/// - Parameter action: A closure to be executed.
/// - Returns: A closure that performs the given action and hides the keyboard.
public func actionWithHideKeyboard(_ action: @escaping () -> Void) -> () -> Void {
    return {
        action()
        hideKeyboard()
    }
}
#endif
