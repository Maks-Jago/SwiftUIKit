//===--- UIKitAppear.swift ---------------------------------------===//
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
    
    /// Executes a closure when the view appears, using UIKit's `viewDidAppear`.
    /// - Parameter perform: A closure to execute when the view appears.
    /// - Returns: A modified view that performs the closure on appear.
    func uiKitOnAppear(_ perform: @escaping () -> Void) -> some View {
        self.background(UIKitAppear(action: perform))
    }
}

struct UIKitAppear: UIViewControllerRepresentable {
    let action: () -> Void
    
    func makeUIViewController(context: Context) -> UIAppearViewController {
        let vc = UIAppearViewController()
        vc.action = action
        return vc
    }
    
    func updateUIViewController(_ controller: UIAppearViewController, context: Context) {}
}

final class UIAppearViewController: UIViewController {
    var action: () -> Void = {}
    
    override func viewDidLoad() {
        view.addSubview(UILabel())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        action()
    }
}
#endif
