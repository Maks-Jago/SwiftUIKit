//
//  PreviewDevice.swift
//  SwiftUIKit
//
//  Created by Max Kuznetsov on 25.10.2020.
//

import SwiftUI

public extension PreviewDevice {
    static let iPhoneSE: PreviewDevice = .init(rawValue: "iPhone SE")
    static let iPhone8: PreviewDevice = .init(rawValue: "iPhone 8")
    static let iPhone8Plus: PreviewDevice = .init(rawValue: "iPhone 8 Plus")
    static let iPhone11: PreviewDevice = .init(rawValue: "iPhone 11")
    static let iPhone11Pro: PreviewDevice = .init(rawValue: "iPhone 11 Pro")
    static let iPhone11ProMax: PreviewDevice = .init(rawValue: "iPhone 11 Pro Max")
}

// MARK: - PreviewOnDevices
public extension PreviewDevice {
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
    public var id: UUID { .init() }
}

// MARK: - CaseIterable
extension PreviewDevice: CaseIterable {
    public static var allCases: [PreviewDevice] = [.iPhone11ProMax, .iPhone11Pro, .iPhone11, .iPhone8Plus, .iPhone8, .iPhoneSE]
}