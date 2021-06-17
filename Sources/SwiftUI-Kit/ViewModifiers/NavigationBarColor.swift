//
//  NavigationBarColor.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import SwiftUI

public extension View {
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
            content.configureNavigationController { navContoller in
                navContoller.navigationBar.backgroundColor = backgroundColor
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
