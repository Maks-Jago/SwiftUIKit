//
//  ButtonStyle.swift
//  SwiftUIKit
//
//  Created by Lena Soroka on 26.03.2024.
//

import SwiftUI

// MARK: - RoundedButtonStyle
struct RoundedButtonStyle: ButtonStyle {
    struct ButtonText {
        var font: Font
        var padding: CGFloat
        var color: Color = .white
    }
    
    struct ButtonBorder {
        var width: CGFloat = 1
        var color: Color = .clear
    }
    
    var text: ButtonText
    var border: ButtonBorder
    var height: CGFloat
    var cornerRadius: CGFloat
    var backgroundColor: Color
    
    init(
        text: ButtonText,
        border: ButtonBorder,
        height: CGFloat,
        cornerRadius: CGFloat,
        backgroundColor: Color
    ) {
        self.text = text
        self.border = border
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(backgroundColor)
            .frame(height: height)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: border.width)
                    .fill(border.color)
                    .overlay(
                        configuration.label
                            .font(text.font)
                            .foregroundColor(text.color)
                            .padding(text.padding)
                    )
            )
            .opacity(configuration.isPressed ? 0.2 : 1.0)
    }
}
