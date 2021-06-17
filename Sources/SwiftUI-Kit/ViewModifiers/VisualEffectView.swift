//
//  VisualEffectView.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import SwiftUI

public extension View {
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

public struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    public func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) { uiView.effect = effect }
}
#endif
