//===--- RoundedCorner.swift -------------------------------------===//
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
    
    /// Applies a rounded corner to the specified corners of the view.
    /// - Parameters:
    ///   - radius: The radius of the corner rounding.
    ///   - corners: The corners to apply the rounding to. Default is `.allCorners`.
    /// - Returns: A view with the specified corners rounded.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

/// A shape that rounds specified corners of a rectangle.
public struct RoundedCorner: Shape {
    public var radius: CGFloat
    public var corners: UIRectCorner
    
    /// Creates a `RoundedCorner` shape.
    /// - Parameters:
    ///   - radius: The radius of the corner rounding. Default is `.infinity`.
    ///   - corners: The corners to apply the rounding to. Default is `.allCorners`.
    public init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
#endif
