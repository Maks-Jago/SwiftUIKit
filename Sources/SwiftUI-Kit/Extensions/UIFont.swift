//
//  UIFont.swift
//  SwiftUIKit
//
//  Created by  Vladyslav Fil on 22.09.2021.
//

import UIKit

public extension UIFont {
    func calculateHeight(text: String, width: CGFloat) -> CGFloat {
        let constraintSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = (text as NSString).boundingRect(
            with: constraintSize,
            options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.pointSize)],
            context: nil
        )
        
        return max(CGFloat(ceilf(Float(boundingBox.height))), lineHeight)
    }
}
