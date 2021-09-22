//
//  NSAttributedString.swift
//  SwiftUIKit
//
//  Created by  Vladyslav Fil on 22.09.2021.
//

import SwiftUI

//MARK: - Attributed String By Trimming CharacterSet
public extension NSAttributedString {
    func attributedStringByTrimmingCharacterSet(charSet: CharacterSet) -> NSAttributedString {
        let modifiedString = NSMutableAttributedString(attributedString: self)
        modifiedString.trimCharactersInSet(charSet: charSet)
        return NSAttributedString(attributedString: modifiedString)
     }
}

//MARK: - Trim Characters In Set
public extension NSMutableAttributedString {
    func trimCharactersInSet(charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet as CharacterSet)

         // Trim leading characters from character set.
         while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
         }

         // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
         while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
         }
     }
}

//MARK: - Change Line
public extension NSAttributedString {
    func changeLine(height: CGFloat, spacing: CGFloat) -> NSAttributedString {
        let newStr = self.mutableCopy() as! NSMutableAttributedString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = height
        paragraphStyle.maximumLineHeight = height
        paragraphStyle.lineSpacing = spacing
        
        newStr.beginEditing()
        newStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, newStr.length))
        newStr.endEditing()
        return newStr
    }
}

//MARK: - Replace Substring
public extension NSAttributedString {
    func replaceSubstring(in range: NSRange, with text: String) -> NSAttributedString {
        let newStr = self.mutableCopy() as! NSMutableAttributedString
        newStr.replaceCharacters(in: range, with: text)
        return newStr
    }
}

//MARK: - Make Underscored
public extension NSAttributedString {
    func makeUnderscored(text: String) -> NSAttributedString {
        let ranges = self.string.ranges(of: text)
        
        guard !ranges.isEmpty else {
            return self
        }
        let nsRanges = ranges.map { NSRange($0, in: self.string) }
        
        let newStr = self.mutableCopy() as! NSMutableAttributedString
        newStr.beginEditing()
        for nsRange in nsRanges {
            newStr.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: nsRange)
        }
        newStr.endEditing()
        return newStr
    }
}

//MARK: - Set Color
public extension NSAttributedString {
    func setColor(for text: String, color: UIColor) -> NSAttributedString {
        let ranges = self.string.ranges(of: text)
        
        guard !ranges.isEmpty else {
            return self
        }
        let nsRanges = ranges.map { NSRange($0, in: self.string) }
        
        let newStr = self.mutableCopy() as! NSMutableAttributedString
        newStr.beginEditing()
        for nsRange in nsRanges {
            newStr.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        newStr.endEditing()
        return newStr
    }
}

//MARK: - Set Font
public extension NSAttributedString {
    func setFont(for text: String, font: UIFont) -> NSAttributedString {
        let ranges = self.string.ranges(of: text)
        
        guard !ranges.isEmpty else {
            return self
        }
        let nsRanges = ranges.map { NSRange($0, in: self.string) }
        
        let newStr = self.mutableCopy() as! NSMutableAttributedString
        newStr.beginEditing()
        for nsRange in nsRanges {
            newStr.addAttribute(.font, value: font, range: nsRange)
        }
        newStr.endEditing()
        return newStr
    }
    
    func setFont(for words: [String], font: UIFont) -> NSAttributedString {
        let newStr = self.mutableCopy() as! NSMutableAttributedString
        newStr.beginEditing()
        
        for word in words {
            let ranges = self.string.ranges(of: word)
            
            guard !ranges.isEmpty else {
                continue
            }
            
            let nsRanges = ranges.map { NSRange($0, in: self.string) }
            
            for nsRange in nsRanges {
                newStr.addAttribute(.font, value: font, range: nsRange)
            }
        }
        newStr.endEditing()
        
        return newStr
    }
}
