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

// MARK: HTML
/// Example usage:
/// ```swift
/// let attributedString = model.htmlDescription
///                             .htmlWithListMarkers()
///                             .convertHtmlUTF16()
///
/// ```
public extension String {
    /// Converts the string (assumed to be HTML) into an `NSAttributedString` using UTF-16 encoding.
    ///
    /// This method injects default styling into the HTML content (using `Montserrat-Medium` at 14pt)
    /// and attempts to parse it as a styled `NSAttributedString`.
    ///
    /// - Returns: An optional `NSAttributedString` if conversion succeeds; otherwise, `nil`.
    func convertHtmlUTF16(fontFamily: String, fontSize: CGFloat) -> NSAttributedString? {
        let htmlWithStyles = """
        <style>
        body {
            font-family: '\(fontFamily)', sans-serif;
            font-size: \(fontSize)px;
        }
        </style>
        \(self)
        """

        guard let styledData = htmlWithStyles.data(using: .utf16),
              let attributedString = try? NSAttributedString(
                  data: styledData,
                  options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf16.rawValue,
                  ],
                  documentAttributes: nil
              ) else { return nil }

        return attributedString
    }

    /// Transforms custom HTML list markers from Quill.js (or similar editors) into standard list formats.
    ///
    /// Specifically:
    /// - Replaces bullet lists (with `data-list="bullet"`) with `"•"` prefix.
    /// - Replaces ordered lists (with `data-list="ordered"`) by prepending index numbers like `1.`, `2.`, etc.
    ///
    /// This is useful when handling raw HTML exported from rich text editors that use `<span class="ql-ui">` elements
    /// to simulate list bullets/numbers, which aren't visually meaningful in native rendering.
    ///
    /// - Returns: A modified HTML string with recognizable list markers.
    func htmlWithListMarkers() -> String {
        var html = self

        let bulletPattern = #"<li\s+data-list="bullet"><span class="ql-ui"[^>]*></span>"#
        html = html.replacingOccurrences(
            of: bulletPattern,
            with: "<li>• ",
            options: .regularExpression
        )

        let orderedPattern = #"<li\s+data-list="ordered"><span class="ql-ui"[^>]*></span>"#
        guard let regex = try? NSRegularExpression(
            pattern: orderedPattern,
            options: []
        ) else {
            return html
        }

        var counter = 0
        let matches = regex.matches(
            in: html,
            options: [],
            range: NSRange(html.startIndex..., in: html)
        )
        var result = ""
        var lastIndex = html.startIndex

        for m in matches {
            let range = Range(m.range, in: html)!
            result += String(html[lastIndex ..< range.lowerBound])
            counter += 1
            result += "<li>\(counter). "
            lastIndex = range.upperBound
        }

        result += String(html[lastIndex...])
        return result
    }
}
