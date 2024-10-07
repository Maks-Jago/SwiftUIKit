//===--- SwipeToDismiss.swift ------------------------------------===//
//
// This source file is part of the SwiftUI-Kit open source project
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
    
    /// Allows swipe-to-dismiss behavior on the view based on a custom condition.
    /// - Parameter dismissable: A closure that returns a Boolean value indicating whether the view can be dismissed.
    /// - Returns: A modified view that supports swipe-to-dismiss behavior.
    func allowSwipeToDismiss(_ dismissable: @escaping () -> Bool) -> some View {
        background(SwipeToDismissWrapper(dismissable: dismissable))
    }
    
    /// Allows swipe-to-dismiss behavior on the view based on a fixed Boolean value.
    /// - Parameter dismiss: A Boolean value indicating whether the view can be dismissed.
    /// - Returns: A modified view that supports swipe-to-dismiss behavior.
    func allowSwipeToDismiss(_ dismiss: Bool) -> some View {
        background(SwipeToDismissWrapper(dismissable: { dismiss }))
    }
}

private struct SwipeToDismissWrapper: UIViewControllerRepresentable {
    var dismissable: () -> Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<Self>) {
        rootViewController(of: uiViewController).presentationController?.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(dismissable: dismissable)
    }
    
    final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var dismissable: () -> Bool
        
        init(dismissable: @escaping () -> Bool) {
            self.dismissable = dismissable
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            dismissable()
        }
    }
    
    /// Recursively finds the root view controller from a given view controller.
    /// - Parameter uiViewController: The view controller to start the search from.
    /// - Returns: The root view controller.
    private func rootViewController(of uiViewController: UIViewController) -> UIViewController {
        if let parent = uiViewController.parent {
            return rootViewController(of: parent)
        } else {
            return uiViewController
        }
    }
}
#endif
