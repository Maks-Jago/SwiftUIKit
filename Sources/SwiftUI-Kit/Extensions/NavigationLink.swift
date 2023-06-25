//
//  NavigationLink.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 08.12.2020.
//

import SwiftUI

public extension NavigationLink where Label == EmptyView {

    init(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination) {
        self.init(isActive: isActive, destination: destination) { EmptyView() }
    }
}
