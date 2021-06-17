//
//  NavigationControllerConfigurator.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import SwiftUI

public extension View {
    func configureNavigationController(_ configure: @escaping (UINavigationController) -> Void) -> some View {
        background(NavigationControllerConfigurator(configure: configure))
    }
}

struct NavigationControllerConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void
    
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
