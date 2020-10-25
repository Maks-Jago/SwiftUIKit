//
//  NavigationControllerConfigurator.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    func configureNavigationController(_ configure: @escaping (UINavigationController) -> Void) -> some View {
        self.background(NavigationControllerConfigurator(configure: configure))
    }
}

public struct NavigationControllerConfigurator: UIViewControllerRepresentable {
    public var configure: (UINavigationController) -> Void = { _ in }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
