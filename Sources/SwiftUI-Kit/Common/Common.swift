//===--- Common.swift --------------------------------------------===//
//
// This source file is part of the SwiftUI-Kit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

#if canImport(UIKit)
import UIKit

/// Obtains the key window from the application's connected scenes.
/// - Returns: The current key `UIWindow` if available, or `nil` if not found.
public func obtainKeyWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    
    for scene in scenes {
        if let keyWindow = scene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow
        }
    }
    
    return nil
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
