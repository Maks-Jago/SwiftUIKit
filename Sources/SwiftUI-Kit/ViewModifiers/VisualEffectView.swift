//===--- VisualEffectView.swift ----------------------------------===//
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
import SwiftUI

public extension View {
    
    /// Adds a `UIVisualEffect` as the background of the view.
    /// - Parameter effect: The visual effect to apply as the background. Default is `nil`.
    /// - Returns: A view with the specified visual effect as its background.
    func addVisualEffectAsBackground(effect: UIVisualEffect? = nil) -> some View {
        self.modifier(VisualEffectViewModifier(effect: effect))
    }
}

private struct VisualEffectViewModifier: ViewModifier {
    let effect: UIVisualEffect?
    
    func body(content: Content) -> some View {
        content.background(VisualEffectView(effect: effect))
    }
}

/// A `UIViewRepresentable` that wraps a `UIVisualEffectView` to be used in SwiftUI.
public struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}
#endif
