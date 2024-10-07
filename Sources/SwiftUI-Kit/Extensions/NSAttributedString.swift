//===--- NSAttributedString.swift --------------------------------===//
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
public extension NSAttributedString {
    
    /// Sets the font for specific text within the attributed string.
    /// - Parameters:
    ///   - text: The text for which the font should be changed.
    ///   - font: The new `UIFont` to apply to the specified text.
    /// - Returns: A new `NSAttributedString` with the updated font for the specified text.
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
    
    /// Sets the font for multiple words within the attributed string.
    /// - Parameters:
    ///   - words: An array of words for which the font should be changed.
    ///   - font: The new `UIFont` to apply to the specified words.
    /// - Returns: A new `NSAttributedString` with the updated font for the specified words.
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

#else
import AppKit

public extension NSAttributedString {
    
    /// Sets the font for specific text within the attributed string (macOS version).
    /// - Parameters:
    ///   - text: The text for which the font should be changed.
    ///   - font: The new `NSFont` to apply to the specified text.
    /// - Returns: A new `NSAttributedString` with the updated font for the specified text.
    func setFont(for text: String, font: NSFont) -> NSAttributedString {
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
    
    /// Sets the font for multiple words within the attributed string (macOS version).
    /// - Parameters:
    ///   - words: An array of words for which the font should be changed.
    ///   - font: The new `NSFont` to apply to the specified words.
    /// - Returns: A new `NSAttributedString` with the updated font for the specified words.
    func setFont(for words: [String], font: NSFont) -> NSAttributedString {
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

#endif

// MARK: - Attributed String By Trimming CharacterSet
public extension NSAttributedString {
    
    /// Trims characters from the beginning and end of the attributed string based on the specified character set.
    /// - Parameter charSet: The character set used to trim characters from the string.
    /// - Returns: A new `NSAttributedString` with the characters trimmed.
    func attributedStringByTrimmingCharacterSet(charSet: CharacterSet) -> NSAttributedString {
        let modifiedString = NSMutableAttributedString(attributedString: self)
        modifiedString.trimCharactersInSet(charSet: charSet)
        return NSAttributedString(attributedString: modifiedString)
    }
}

// MARK: - Trim Characters In Set
public extension NSMutableAttributedString {
    
    /// Trims characters from the beginning and end of the mutable attributed string based on the specified character set.
    /// - Parameter charSet: The character set used to trim characters from the string.
    func trimCharactersInSet(charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet)
        
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

// MARK: - Change Line
public extension NSAttributedString {
    
    /// Changes the line height and spacing for the entire attributed string.
    /// - Parameters:
    ///   - height: The minimum and maximum line height.
    ///   - spacing: The line spacing.
    /// - Returns: A new `NSAttributedString` with the modified line height and spacing.
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

// MARK: - Replace Substring
public extension NSAttributedString {
    
    /// Replaces a substring in the attributed string with new text.
    /// - Parameters:
    ///   - range: The range of the substring to replace.
    ///   - text: The text to replace the substring with.
    /// - Returns: A new `NSAttributedString` with the replaced substring.
    func replaceSubstring(in range: NSRange, with text: String) -> NSAttributedString {
        let newStr = self.mutableCopy() as! NSMutableAttributedString
        newStr.replaceCharacters(in: range, with: text)
        return newStr
    }
}

// MARK: - Make Underscored
public extension NSAttributedString {
    
    /// Applies an underline style to the specified text within the attributed string.
    /// - Parameter text: The text to be underscored.
    /// - Returns: A new `NSAttributedString` with the text underscored.
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

#if os(iOS)
import UIKit

// MARK: - Set Color
public extension NSAttributedString {
    
    /// Sets the color of the specified text within the attributed string (iOS version).
    /// - Parameters:
    ///   - text: The text for which the color should be changed.
    ///   - color: The new `UIColor` to apply to the specified text.
    /// - Returns: A new `NSAttributedString` with the updated color for the specified text.
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

#else
import AppKit

// MARK: - Set Color
public extension NSAttributedString {
    
    /// Sets the color of the specified text within the attributed string (macOS version).
    /// - Parameters:
    ///   - text: The text for which the color should be changed.
    ///   - color: The new `NSColor` to apply to the specified text.
    /// - Returns: A new `NSAttributedString` with the updated color for the specified text.
    func setColor(for text: String, color: NSColor) -> NSAttributedString {
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

#endif
