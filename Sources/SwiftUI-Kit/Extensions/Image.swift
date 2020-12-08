//
//  Image.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension Image {
    var original: Self {
        self.renderingMode(.original)
    }
    
    func aspectFit() -> some View {
        self.resizable().aspectRatio(contentMode: .fit)
    }
    
    func aspectFill()  -> some View {
        self.resizable().aspectRatio(contentMode: .fill)
    }
}
