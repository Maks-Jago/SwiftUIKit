//
//  Collection.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 07.07.2025.
//

public extension Collection {
    /// A convenience property that returns the inverse of `isEmpty`.
    /// Useful for improving code readability when checking that a collection contains elements.
    var isNotEmpty: Bool {
        !isEmpty
    }
}
