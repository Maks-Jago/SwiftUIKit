//===--- UIDevice+Extensions.swift -------------------------------===//
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
import UIKit

public extension UIDevice {
    
    /// Checks if the device is an iPhone SE (1st generation).
    static var isIPhoneSE: Bool {
        return (UIScreen.main.bounds.size.height == 568)
    }
    
    /// Checks if the device is an iPhone 8.
    static var isIPhone8: Bool {
        return (UIScreen.main.bounds.size.height == 667)
    }
    
    /// Checks if the device is an iPhone X.
    static var isIPhoneX: Bool {
        return (UIScreen.main.bounds.size.height == 812)
    }
    
    /// Checks if the device is an iPad.
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Checks if the device is currently in landscape orientation.
    static var isLandscapeOrientation: Bool {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    /// Checks if the device is a smaller iPhone (less than iPhone X size).
    static var isSmallIPhone: Bool {
        return (UIScreen.main.bounds.size.height < 812)
    }
    
    /// Checks if the device is an iPhone 8 Plus.
    static var isIphone8Plus: Bool {
        return (UIScreen.main.bounds.size.height == 736)
    }
}
#endif
