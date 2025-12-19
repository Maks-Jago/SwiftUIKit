//
//  ContentSafeAreaEnvironment.swift
//  SwiftUIKit
//
//  Created by Pektanych Bohdan on 19.12.2025.
//

import SwiftUI

struct ContentSafeAreaInsets: EnvironmentKey, PreferenceKey {
  static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
    value = nextValue()
  }
  
  static let defaultValue: EdgeInsets = .init()
}

public extension EnvironmentValues {
  var contentSafeAreaInsets: EdgeInsets {
    get { self[ContentSafeAreaInsets.self] }
    set { self[ContentSafeAreaInsets.self] = newValue }
  }
}
