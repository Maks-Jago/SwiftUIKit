//
//  ConditionalBlur.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//

import SwiftUI

public struct ConditionalBlur: ViewModifier {
    /// Activates or not the blurred modifier
    private let isActive: Bool
    /// Sets a custom radius intensity for the view to blur
    private let radius: CGFloat

    public init(isActive: Bool, radius: CGFloat) {
        self.isActive = isActive
        self.radius = radius
    }

    public func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? radius : 0)
    }
}

public extension View {
    func conditionalBlur(isActive: Bool, radius: CGFloat = 10) -> some View {
        self.modifier(ConditionalBlur(isActive: isActive, radius: radius))
    }
}
