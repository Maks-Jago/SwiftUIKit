//===--- LoaderSheet.swift ---------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

#if canImport(UIKit)
import SwiftUI

@available(iOS 14.0, *)
public extension View {
    
    /// Displays a loading sheet with an activity indicator and a customizable title.
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the loader sheet is presented.
    ///   - title: The title to display on the loader sheet. Default is "Loading...".
    ///   - font: The font to use for the title. Default is `.body`.
    ///   - indicatorColor: The color of the activity indicator. Default is `.black`.
    ///   - titleColor: The color of the title text. Default is `.black`.
    ///   - backgroundColor: The background color of the loader sheet. Default is `.white`.
    /// - Returns: A modified view that displays the loader sheet when `isPresented` is `true`.
    func loaderSheet(
        isPresented: Binding<Bool>,
        title: String = Bundle.main.localizedString(forKey: "Loading...", value: nil, table: nil),
        font: Font = .body,
        indicatorColor: Color = .black,
        titleColor: Color = .black,
        backgroundColor: Color = .white
    ) -> some View {
        self.modifier(
            LoaderSheet(
                isPresented: isPresented.animation(),
                title: title,
                font: font,
                indicatorColor: indicatorColor,
                titleColor: titleColor,
                backgroundColor: backgroundColor
            )
        )
    }
}

@available(iOS 14.0, *)
public struct LoaderSheet: ViewModifier {
    @Binding public var isPresented: Bool
    public let title: String
    public let font: Font
    public let indicatorColor: Color
    public let titleColor: Color
    public let backgroundColor: Color
    
    /// Creates a `LoaderSheet` view modifier.
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the loader sheet is presented.
    ///   - title: The title to display on the loader sheet.
    ///   - font: The font to use for the title.
    ///   - indicatorColor: The color of the activity indicator.
    ///   - titleColor: The color of the title text.
    ///   - backgroundColor: The background color of the loader sheet.
    public init(
        isPresented: Binding<Bool>,
        title: String,
        font: Font,
        indicatorColor: Color,
        titleColor: Color,
        backgroundColor: Color
    ) {
        self._isPresented = isPresented
        self.title = title
        self.font = font
        self.indicatorColor = indicatorColor
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                content
                    .allowsHitTesting(!self.isPresented)
                    .blur(radius: self.isPresented ? 3 : 0)
                
                if self.isPresented {
                    VStack {
                        ActivityIndicator(
                            isAnimating: self.$isPresented,
                            style: .large,
                            color: UIColor(indicatorColor)
                        )
                        Text(self.title)
                            .font(font)
                            .foregroundColor(titleColor)
                    }
                    .frame(width: proxy.size.width / 2, height: proxy.size.height / 5)
                    .background(backgroundColor)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(AnyTransition.scale.animation(.spring()))
                    .zIndex(100)
                }
            }
        }
    }
}
#endif
