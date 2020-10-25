//
//  SwipeToDismiss.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension View {
    func allowSwipeToDismiss(_ dismissable: @escaping () -> Bool) -> some View {
        background(SwipeToDismissWrapper(dismissable: dismissable))
    }
    
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
    
    private func rootViewController(of uiViewController: UIViewController) -> UIViewController {
        if let parent = uiViewController.parent {
            return rootViewController(of: parent)
        } else {
            return uiViewController
        }
    }
}

