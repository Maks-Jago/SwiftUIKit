//
//  UIApplication.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import UIKit

public extension UIApplication {
    var currentKeyWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
}
#endif
