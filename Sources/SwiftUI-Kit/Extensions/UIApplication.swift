//===--- UIApplication+Extensions.swift --------------------------===//
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

public extension UIApplication {
    
    /// Returns the currently active window of the application.
    /// - Returns: The `UIWindow` that is currently active and in the foreground.
    var activeWindow: UIWindow? {
        var scenes = connectedScenes
            .filter { $0.activationState == .foregroundActive }
        
        if scenes.isEmpty {
            scenes = connectedScenes
        }
        
        return scenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    /// Ends editing in the current application, dismissing the keyboard if it is active.
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
