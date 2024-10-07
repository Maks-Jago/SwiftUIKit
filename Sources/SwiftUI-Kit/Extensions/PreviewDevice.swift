//===--- PreviewDevice.swift -------------------------------------===//
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

public extension PreviewDevice {
    
    /// Commonly used `PreviewDevice` instances for different iPhone models.
    static let iPhoneSE: PreviewDevice = .init(rawValue: "iPhone SE (1st generation)")
    static let iPhoneSE2: PreviewDevice = .init(rawValue: "iPhone SE (2nd generation)")
    static let iPhone8: PreviewDevice = .init(rawValue: "iPhone 8")
    static let iPhone8Plus: PreviewDevice = .init(rawValue: "iPhone 8 Plus")
    static let iPhone11: PreviewDevice = .init(rawValue: "iPhone 11")
    static let iPhone11Pro: PreviewDevice = .init(rawValue: "iPhone 11 Pro")
    static let iPhone11ProMax: PreviewDevice = .init(rawValue: "iPhone 11 Pro Max")
}

// MARK: - PreviewOnDevices
public extension PreviewDevice {
    
    /// Creates a preview of the given content on multiple devices.
    /// - Parameters:
    ///   - devices: An array of `PreviewDevice` instances. Defaults to all available devices.
    ///   - contentBuilder: A view builder that creates the content to be previewed.
    /// - Returns: A view that displays the content on each specified device.
    static func previewOnDevices<V: View>(_ devices: [PreviewDevice] = PreviewDevice.allCases, @ViewBuilder contentBuilder: @escaping () -> V) -> some View {
        Group {
            ForEach(devices) {
                contentBuilder()
                    .previewDevice($0)
                    .previewDisplayName($0.rawValue)
            }
        }
    }
}

// MARK: - Identifiable
extension PreviewDevice: Identifiable {
    
    /// A unique identifier for each `PreviewDevice`.
    public var id: String { rawValue }
}

// MARK: - CaseIterable
extension PreviewDevice: CaseIterable {
    
    /// A collection of all available `PreviewDevice` instances.
    public static var allCases: [PreviewDevice] = [.iPhone11ProMax, .iPhone11Pro, .iPhone11, .iPhone8Plus, .iPhone8, .iPhoneSE]
}
