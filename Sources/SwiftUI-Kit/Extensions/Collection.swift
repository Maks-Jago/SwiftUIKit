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

public extension Collection where Self.Element: Hashable {
    /// Returns a Boolean value indicating whether the collection contains the specified `AnyHashable` element.
    /// - Parameter element: The `AnyHashable` element to search for in the collection.
    /// - Returns: `true` if the collection contains the specified element; otherwise, `false`.
    func contains(_ element: AnyHashable) -> Bool {
        contains { elem  in
            AnyHashable(elem) == element
        }
    }
}
