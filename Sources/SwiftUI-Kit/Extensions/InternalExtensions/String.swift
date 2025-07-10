//
//  String.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 10.07.2025.
//

// MARK: - Identifiable
extension String: Identifiable {
    /// The string itself as its unique identifier.
    public var id: String { self }
}

extension String {
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
