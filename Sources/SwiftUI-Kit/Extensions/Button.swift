//
//  Button.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension Button where Label == Image {
    init(image: Label, action: @escaping () -> Void) {
        self.init(action: action) {
            image.original
        }
    }
}
