//
//  View+Embed.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    func embedInScrollView(alignment: Alignment = .center) -> some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                self.frame(
                    minHeight: proxy.size.height,
                    maxHeight: .infinity,
                    alignment: alignment
                )
            }
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func embedInNavigationLink<T: View>(link: @escaping () -> T?) -> some View {
        IfLetViewPlaceholder(value: link, content: {
            NavigationLink(destination: $0) {
                self
            }
        }) {
            self
        }
    }
}
