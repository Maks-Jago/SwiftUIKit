//
//  SafeAreaProvider.swift
//  SwiftUIKit
//
//  Created by Petkanych Bohdan on 19.12.2025.
//

import SwiftUI

struct SafeAreaProvider<Content: View>: View {
  @State private var insets: EdgeInsets = .init()
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    content
      .environment(\.contentSafeAreaInsets, insets)
      .background(
        GeometryReader { proxy in
          Color.clear
            .onAppear {
              insets = proxy.safeAreaInsets
            }
            .preference(
              key: ContentSafeAreaInsets.self,
              value: proxy.safeAreaInsets
            )
            .onPreferenceChange(ContentSafeAreaInsets.self) { value in
              insets = value
            }
        }
      )
  }
}
