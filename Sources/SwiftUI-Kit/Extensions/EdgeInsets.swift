//===--- EdgeInsets.swift ----------------------------------------===//
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

public extension EdgeInsets {
    
    /// A static property representing zero edge insets for all edges.
    static var zero: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    /// Creates edge insets with the specified value applied to the top and bottom edges.
    /// - Parameter value: The inset value to apply vertically.
    /// - Returns: An `EdgeInsets` object with the given value for the top and bottom edges.
    static func vertical(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: 0, bottom: value, trailing: 0)
    }
    
    /// Creates edge insets with the specified value applied to the leading and trailing edges.
    /// - Parameter value: The inset value to apply horizontally.
    /// - Returns: An `EdgeInsets` object with the given value for the leading and trailing edges.
    static func horizontal(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: value, bottom: 0, trailing: value)
    }
    
    /// Creates edge insets with the specified value applied to the top edge.
    /// - Parameter value: The inset value to apply to the top edge.
    /// - Returns: An `EdgeInsets` object with the given value for the top edge.
    static func top(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: 0, bottom: 0, trailing: 0)
    }
}
