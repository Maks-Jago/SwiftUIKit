//===--- NavigationBarColor.swift --------------------------------===//
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
    
    /// Modifies the navigation bar's color, shadow, and title color.
    /// - Parameters:
    ///   - backgroundColor: The background color of the navigation bar. Default is `.white`.
    ///   - shadowColor: The color of the navigation bar's shadow. Default is `.clear`.
    ///   - titleColor: The color of the navigation bar's title. Default is `.black`.
    /// - Returns: A view modified with the specified navigation bar colors.
    func navigationBarColor(_ backgroundColor: UIColor = .white, shadowColor: UIColor = .clear, titleColor: UIColor = .black) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, shadowColor: shadowColor, titleColor: titleColor))
    }
}

private struct NavigationBarColor: ViewModifier {
    var backgroundColor: UIColor
    var shadowColor: UIColor
    
    init(backgroundColor: UIColor, shadowColor: UIColor, titleColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        
        coloredAppearance.shadowColor = shadowColor
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content.configureNavigationController { navController in
                navController.navigationBar.backgroundColor = backgroundColor
            }
            
            VStack {
                GeometryReader { geometry in
                    Color(backgroundColor)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

struct NavigationBarColor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color.white.navigationBarColor(.blue, shadowColor: .red, titleColor: .yellow)
                .navigationBarTitle(Text("Navigation title"))
        }
    }
}
#endif
