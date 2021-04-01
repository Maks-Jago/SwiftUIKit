//
//  UIKitAppear.swift
//  
//
//  Created by Max Kuznetsov on 01.04.2021.
//

import SwiftUI

public extension View {
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
