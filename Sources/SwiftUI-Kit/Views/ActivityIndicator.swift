//
//  ActivityIndicator.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import SwiftUI

public struct ActivityIndicator: UIViewRepresentable {
    @Binding public var isAnimating: Bool
    public let style: UIActivityIndicatorView.Style
    public let color: UIColor
    
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
