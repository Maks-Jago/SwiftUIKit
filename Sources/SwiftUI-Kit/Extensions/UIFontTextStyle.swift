//
//  UIFontTextStyle.swift
//  SwiftUIKit
//
//  Created by  Vladyslav Fil on 22.09.2021.
//

import SwiftUI

public extension UIFont.TextStyle {
    
    init?(_ textStyle: Font.TextStyle) {
        let styles: [Font.TextStyle: UIFont.TextStyle] = [
            .largeTitle: .largeTitle,
            .title: .title1,
            .headline: .headline,
            .subheadline: .subheadline,
            .body: .body,
            .callout: .callout,
            .footnote: .footnote,
            .caption: .caption1
        ]
        
        guard let style = styles[textStyle] else {
            return nil
        }
        
        self = style
    }
}
