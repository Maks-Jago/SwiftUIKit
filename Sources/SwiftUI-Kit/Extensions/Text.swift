//
//  Text.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 07.07.2025.
//

import SwiftUI

public extension Text {
    /// Applies both font and color styling to a `Text` view, using `foregroundStyle` on iOS 17+ and `foregroundColor` on earlier versions.
    ///
    /// - Parameters:
    ///   - type: The font to apply.
    ///   - color: The color to apply to the text.
    /// - Returns: A view with the specified font and color styling applied.
    func font(_ type: Font, color: Color) -> Self {
        if #available(iOS 17.0, *) {
            font(type)
                .foregroundStyle(color)
        } else {
            font(type)
                .foregroundColor(color)
        }
    }
}
