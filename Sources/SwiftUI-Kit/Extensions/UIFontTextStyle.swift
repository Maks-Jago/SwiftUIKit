//===--- UIFontTextStyle+Extensions.swift ------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

#if os(iOS)
import SwiftUI

@available(iOS 14, *)
public extension UIFont.TextStyle {
    
    /// Initializes a `UIFont.TextStyle` from a corresponding SwiftUI `Font.TextStyle`.
    /// - Parameter textStyle: The `Font.TextStyle` to convert.
    /// - Returns: A `UIFont.TextStyle` if the conversion is successful; otherwise, returns `nil`.
    init?(_ textStyle: Font.TextStyle) {
        let styles: [Font.TextStyle: UIFont.TextStyle] = [
            .largeTitle: .largeTitle,
            .title: .title1,
            .title2: .title2,
            .title3: .title3,
            .headline: .headline,
            .subheadline: .subheadline,
            .body: .body,
            .callout: .callout,
            .footnote: .footnote,
            .caption: .caption1,
            .caption2: .caption2
        ]
        
        guard let style = styles[textStyle] else {
            return nil
        }
        
        self = style
    }
}
#endif
