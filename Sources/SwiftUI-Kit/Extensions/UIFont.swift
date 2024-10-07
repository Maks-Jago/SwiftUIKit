//===--- UIFont+Extensions.swift ---------------------------------===//
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
import UIKit

public extension UIFont {
    
    /// Calculates the height required to display a given text within a specified width using the font.
    /// - Parameters:
    ///   - text: The text for which to calculate the height.
    ///   - width: The width constraint to use when calculating the height.
    /// - Returns: The calculated height required to display the text as a `CGFloat`.
    func calculateHeight(text: String, width: CGFloat) -> CGFloat {
        let constraintSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = (text as NSString).boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.pointSize)],
            context: nil
        )
        
        return max(CGFloat(ceilf(Float(boundingBox.height))), lineHeight)
    }
}
#endif
