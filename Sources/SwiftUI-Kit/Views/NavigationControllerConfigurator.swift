//===--- NavigationControllerConfigurator.swift ------------------===//
//
// This source file is part of the SwiftUIKit open source project
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
    
    /// Configures the navigation controller for the current view.
    /// - Parameter configure: A closure that takes a `UINavigationController` and applies custom configurations to it.
    /// - Returns: A modified view that applies the configuration to the navigation controller.
    func configureNavigationController(_ configure: @escaping (UINavigationController) -> Void) -> some View {
        background(NavigationControllerConfigurator(configure: configure))
    }
}

struct NavigationControllerConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void
    
    /// Initializes a new `NavigationControllerConfigurator`.
    /// - Parameter configure: A closure that configures the `UINavigationController`.
    init(configure: @escaping (UINavigationController) -> Void) {
        self.configure = configure
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
#endif
