//===--- AnimatedRedacted.swift ----------------------------------===//
//
// This source file is part of the SwiftUI-Kit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

import SwiftUI

/// A view modifier that applies an animated redacted effect to a view.
/// When the effect is active, it overlays a gradient animation over the content, creating a shimmering effect.
public struct AnimatedRedactedModifier: ViewModifier {
    public var isActive: Bool
    public var backgroundColor: Color
    public var overlayGradient: LinearGradient
    
    @State private var animated: Bool
    
    /// Creates an `AnimatedRedactedModifier`.
    /// - Parameters:
    ///   - isActive: A Boolean value that determines whether the redacted effect is active.
    ///   - backgroundColor: The background color of the redacted effect. Default is `.gray`.
    ///   - overlayGradient: The gradient overlay used for the shimmering effect. Default is a clear-to-gray gradient.
    public init(
        isActive: Bool,
        backgroundColor: Color = .gray,
        overlayGradient: LinearGradient = .init(colors: [.clear, .gray, .clear], startPoint: .leading, endPoint: .trailing)
    ) {
        self.isActive = isActive
        self.backgroundColor = backgroundColor
        self.overlayGradient = overlayGradient
        self.animated = false
    }
    
    public func body(content: Content) -> some View {
        content
            .if(isActive) {
                $0.overlay(
                    ZStack {
                        backgroundColor
                        GeometryReader { geometry in
                            let width = geometry.size.width
                            let height = geometry.size.height
                            let offset = width * 2.5
                            let diagonal = sqrt(pow(width, 2) + pow(height, 2))
                            let scale = diagonal / min(width, height)
                            overlayGradient
                                .offset(x: animated ? offset : -offset)
                                .rotationEffect(.init(degrees: -45))
                                .scaleEffect(scale, anchor: .center)
                                .animation(
                                    .linear(duration: 1.5).repeatForever(autoreverses: false),
                                    value: animated
                                )
                                .onAppear { animated = true }
                        }
                    }
                        .mask(Rectangle())
                )
            }
    }
}

struct AnimatedRedactedModifier_Previews: PreviewProvider {
    static var previews: some View {
        Rectangle()
            .frame(width: 200, height: 200)
            .modifier(AnimatedRedactedModifier(isActive: true))
    }
}
