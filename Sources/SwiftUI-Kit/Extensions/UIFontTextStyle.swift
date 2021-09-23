//
//  UIFontTextStyle.swift
//  SwiftUIKit
//
//  Created by  Vladyslav Fil on 22.09.2021.
//

import SwiftUI

@available(iOS 14, *)
extension UIFont.TextStyle {
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
