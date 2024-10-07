//===--- String.swift --------------------------------------------===//
//
// This source file is part of the SwiftUIKit open source project
//
// Copyright (c) 2024 You are launched
// Licensed under MIT License
//
// See https://opensource.org/licenses/MIT for license information
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftUI

// MARK: - String: Identifiable
extension String: Identifiable {
    /// A unique identifier for each string, which is the string itself.
    public var id: String { self }
}

#if os(iOS)
import UIKit

public extension String {
    
    /// Calculates the width of the string using the specified font.
    /// - Parameter font: The `UIFont` to be used for calculating the string's width.
    /// - Returns: The width of the string as a `CGFloat`.
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
#else
import AppKit

public extension String {
    
    /// Calculates the width of the string using the specified font (macOS version).
    /// - Parameter font: The `NSFont` to be used for calculating the string's width.
    /// - Returns: The width of the string as a `CGFloat`.
    func widthOfString(usingFont font: NSFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
#endif

// MARK: - StringProtocol Extensions
public extension StringProtocol {
    
    /// Finds the starting index of the first occurrence of a given substring.
    /// - Parameters:
    ///   - string: The substring to search for.
    ///   - options: Options for string comparison. Default is an empty array.
    /// - Returns: The starting index of the substring if found, or `nil` if not found.
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    
    /// Finds the ending index of the first occurrence of a given substring.
    /// - Parameters:
    ///   - string: The substring to search for.
    ///   - options: Options for string comparison. Default is an empty array.
    /// - Returns: The ending index of the substring if found, or `nil` if not found.
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    
    /// Finds all starting indices of occurrences of a given substring.
    /// - Parameters:
    ///   - string: The substring to search for.
    ///   - options: Options for string comparison. Default is an empty array.
    /// - Returns: An array of starting indices for each occurrence of the substring.
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    
    /// Finds all ending indices of occurrences of a given substring.
    /// - Parameters:
    ///   - string: The substring to search for.
    ///   - options: Options for string comparison. Default is an empty array.
    /// - Returns: An array of ending indices for each occurrence of the substring.
    func endIndices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.upperBound)
    }
    
    /// Finds all ranges of a given substring within the string.
    /// - Parameters:
    ///   - string: The substring to search for.
    ///   - options: Options for string comparison. Default is an empty array.
    /// - Returns: An array of ranges representing each occurrence of the substring.
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex, let range = self[startIndex...].range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
