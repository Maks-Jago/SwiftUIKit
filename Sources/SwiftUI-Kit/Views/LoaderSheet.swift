//
//  LoaderSheet.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    func loaderSheet(isPresented: Binding<Bool>, title: String = Bundle.main.localizedString(forKey: "Loading...", value: nil, table: nil)) -> some View {
        self.modifier(LoaderSheet(isPresented: isPresented.animation(), title: title))
    }
}

public struct LoaderSheet: ViewModifier {
    @Binding public var isPresented: Bool
    public let title: String
    
    public init(isPresented: Binding<Bool>, title: String) {
        self._isPresented = isPresented
        self.title = title
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                content
                    .allowsHitTesting(!self.isPresented)
                    .blur(radius: self.isPresented ? 3 : 0)
                
                if self.isPresented {
                    VStack {
                        ActivityIndicator(isAnimating: self.$isPresented, style: .large)
                        Text(self.title).font(.body)
                    }
                    .frame(width: proxy.size.width / 2, height: proxy.size.height / 5)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(AnyTransition.scale.animation(.spring()))
                }
            }
        }
    }
}
