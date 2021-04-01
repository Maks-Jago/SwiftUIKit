//
//  UIDevice.swift
//  
//
//  Created by Max Kuznetsov on 01.04.2021.
//

import UIKit

public extension UIDevice {
    static var isIPhoneSE: Bool {
        return (UIScreen.main.bounds.size.height == 568)
    }
    
    static var isIPhone8: Bool {
        return (UIScreen.main.bounds.size.height == 667)
    }
    
    static var isIPhoneX: Bool {
        return (UIScreen.main.bounds.size.height == 812)
    }
    
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isLandscapeOrientation: Bool {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    
    static var isSmallIPhone: Bool {
        return (UIScreen.main.bounds.size.height < 812)
    }
    
    static var isIphone8Plus: Bool {
        return (UIScreen.main.bounds.size.height == 736)
    }
}

