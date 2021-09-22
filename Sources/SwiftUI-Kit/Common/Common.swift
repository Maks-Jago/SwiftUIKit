//
//  Common.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

#if canImport(UIKit)
import UIKit

public func obtainKeyWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    
    for scene in scenes {
        if let keyWindow = scene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow
        }
    }
    
    return nil
}

public func hideKeyboard() {
    obtainKeyWindow()?.endEditing(true)
}

public func actionWithHideKeyboard(_ action: @escaping () -> Void) -> () -> Void {
    return {
        action()
        hideKeyboard()
    }
}

func rootController() -> UIViewController? {
    return visibleViewController(window: obtainKeyWindow())
}

func visibleViewController(window: UIWindow?) -> UIViewController? {
    guard let window = window else {
        return nil
    }
    let winRoot = window.rootViewController
    var visibleController = winRoot
    func visibleViewController(fromNavController controller: UINavigationController) {
        visibleController = controller.visibleViewController
        if visibleController?.presentedViewController != nil {
            visibleController = visibleController?.presentedViewController
        }
    }
    if let navController = winRoot as? UINavigationController {
        visibleViewController(fromNavController: navController)
    } else if let tabBarContoller = winRoot as? UITabBarController {
        if let navController = tabBarContoller.selectedViewController as? UINavigationController {
            visibleViewController(fromNavController: navController)
        } else {
            visibleController = tabBarContoller.selectedViewController
        }
    }
    return _visibleViewController(vc: visibleController)
}

private func _visibleViewController(vc: UIViewController?) -> UIViewController? {
    if let presentedViewController = vc?.presentedViewController {
        return _visibleViewController(vc: presentedViewController)
    }
    return vc
}
#endif
