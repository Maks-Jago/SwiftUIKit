//===--- ActivityIndicator.swift ---------------------------------===//
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

/// A SwiftUI wrapper for `UIActivityIndicatorView` to display an activity indicator (spinner) in SwiftUI views.
public struct ActivityIndicator: UIViewRepresentable {
    @Binding public var isAnimating: Bool
    public let style: UIActivityIndicatorView.Style
    public let color: UIColor
    
    /// Creates an `ActivityIndicator`.
    /// - Parameters:
    ///   - isAnimating: A binding that controls whether the activity indicator is animating.
    ///   - style: The style of the activity indicator.
    ///   - color: The color of the activity indicator. Default is `.black`.
    public init(isAnimating: Binding<Bool>, style: UIActivityIndicatorView.Style, color: UIColor = .black) {
        self._isAnimating = isAnimating
        self.style = style
        self.color = color
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        return indicator
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
#endif
