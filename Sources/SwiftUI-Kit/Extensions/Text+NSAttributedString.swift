//===--- Text+NSAttributedString.swift ---------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

import SwiftUI

#if os(iOS)
import UIKit
typealias LocalColor = UIColor
typealias LocalFont = UIFont
#else
import AppKit
typealias LocalColor = NSColor
typealias LocalFont = NSFont
#endif

public extension Text {
    
    /// Creates a `Text` view from an `NSAttributedString`, preserving its attributes such as font, color, kerning, strikethrough, baseline offset, and underline.
    /// - Parameter astring: The `NSAttributedString` to convert into a `Text` view.
    init(_ astring: NSAttributedString) {
        self.init("")
        
        astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { (attrs, range, _) in
            var t = Text(astring.attributedSubstring(from: range).string)
            
            // Set the text color if present in the attributed string
            if let color = attrs[NSAttributedString.Key.foregroundColor] as? LocalColor {
                t = t.foregroundColor(Color(color))
            }
            
            // Set the font if present in the attributed string
            if let font = attrs[NSAttributedString.Key.font] as? LocalFont {
                t = t.font(.init(font))
            }
            
            // Set kerning if present in the attributed string
            if let kern = attrs[NSAttributedString.Key.kern] as? CGFloat {
                t = t.kerning(kern)
            }
            
            // Set strikethrough if present in the attributed string
            if let striked = attrs[NSAttributedString.Key.strikethroughStyle] as? NSNumber, striked != 0 {
                if let strikeColor = (attrs[NSAttributedString.Key.strikethroughColor] as? LocalColor) {
                    t = t.strikethrough(true, color: Color(strikeColor))
                } else {
                    t = t.strikethrough(true)
                }
            }
            
            // Set baseline offset if present in the attributed string
            if let baseline = attrs[NSAttributedString.Key.baselineOffset] as? NSNumber {
                t = t.baselineOffset(CGFloat(baseline.floatValue))
            }
            
            // Set underline if present in the attributed string
            if let underline = attrs[NSAttributedString.Key.underlineStyle] as? NSNumber, underline != 0 {
                if let underlineColor = (attrs[NSAttributedString.Key.underlineColor] as? LocalColor) {
                    t = t.underline(true, color: Color(underlineColor))
                } else {
                    t = t.underline(true)
                }
            }
            
            self = self + t
        }
    }
}
