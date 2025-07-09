//
//  HorizontalSliderStile.swift
//  SwiftUIKit
//
//  Created by Vlad Andrieiev on 09.07.2025.
//  Code from https://github.com/spacenation/swiftui-sliders
//

import SwiftUI

/// Defines the implementation of all `ValueSlider` instances within a view
/// hierarchy.
///
/// To configure the current `ValueSlider` for a view hiearchy, use the
/// `.valueSliderStyle()` modifier.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ValueSliderStyle {
    /// A `View` representing the body of a `ValueSlider`.
    associatedtype Body: View

    /// Creates a `View` representing the body of a `ValueSlider`.
    ///
    /// - Parameter configuration: The properties of the value slider instance being
    ///   created.
    ///
    /// This method will be called for each instance of `ValueSlider` created within
    /// a view hierarchy where this style is the current `ValueSliderStyle`.
    func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a `ValueSlider` instance being created.
    typealias Configuration = ValueSliderStyleConfiguration
}

// MARK: - HorizontalValueSliderStyle
public struct HorizontalValueSliderStyle<Track: View, Thumb: View>: ValueSliderStyle {
    private let track: Track
    private let thumb: Thumb
    private let thumbSize: CGSize
    private let thumbInteractiveSize: CGSize
    private let options: ValueSliderOptions

    public func makeBody(configuration: Self.Configuration) -> some View {
        let track = self.track
            .environment(\.trackValue, configuration.value.wrappedValue)
            .environment(
                \.valueTrackConfiguration,
                ValueTrackConfiguration(
                    bounds: configuration.bounds,
                    leadingOffset: self.thumbSize.width / 2,
                    trailingOffset: self.thumbSize.width / 2
                )
            )
            .accentColor(Color.accentColor)

        return GeometryReader { geometry in
            ZStack {
                if self.options.contains(.interactiveTrack) {
                    track.gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gestureValue in
                                configuration.onEditingChanged(true)
                                let computedValue = valueFrom(
                                    distance: gestureValue.location.x,
                                    availableDistance: geometry.size.width,
                                    bounds: configuration.bounds,
                                    step: configuration.step,
                                    leadingOffset: self.thumbSize.width / 2,
                                    trailingOffset: self.thumbSize.width / 2
                                )
                                configuration.value.wrappedValue = computedValue
                            }
                            .onEnded { _ in
                                configuration.onEditingChanged(false)
                            }
                    )
                } else {
                    track
                }

                ZStack {
                    self.thumb
                        .frame(width: thumbSize.width, height: thumbSize.height)
                        .padding(.vertical, (thumbInteractiveSize.height - thumbSize.height) / 2)
                        .padding(.horizontal, (thumbInteractiveSize.width - thumbSize.width) / 2)
                        .contentShape(Circle())
                }
                .frame(minWidth: self.thumbInteractiveSize.width, minHeight: self.thumbInteractiveSize.height)
                .position(
                    x: distanceFrom(
                        value: configuration.value.wrappedValue,
                        availableDistance: geometry.size.width,
                        bounds: configuration.bounds,
                        leadingOffset: self.thumbSize.width / 2,
                        trailingOffset: self.thumbSize.width / 2
                    ),
                    y: geometry.size.height / 2
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gestureValue in
                            configuration.onEditingChanged(true)

                            if configuration.dragOffset.wrappedValue == nil {
                                configuration.dragOffset.wrappedValue = gestureValue.startLocation.x - distanceFrom(
                                    value: configuration.value.wrappedValue,
                                    availableDistance: geometry.size.width,
                                    bounds: configuration.bounds,
                                    leadingOffset: self.thumbSize.width / 2,
                                    trailingOffset: self.thumbSize.width / 2
                                )
                            }

                            let computedValue = valueFrom(
                                distance: gestureValue.location.x - (configuration.dragOffset.wrappedValue ?? 0),
                                availableDistance: geometry.size.width,
                                bounds: configuration.bounds,
                                step: configuration.step,
                                leadingOffset: self.thumbSize.width / 2,
                                trailingOffset: self.thumbSize.width / 2
                            )

                            configuration.value.wrappedValue = computedValue
                        }
                        .onEnded { _ in
                            configuration.dragOffset.wrappedValue = nil
                            configuration.onEditingChanged(false)
                        }
                )
            }
            .frame(height: geometry.size.height)
        }
        .frame(minHeight: self.thumbInteractiveSize.height)
    }

    public init(
        track: Track,
        thumb: Thumb,
        thumbSize: CGSize = CGSize(width: 27, height: 27),
        thumbInteractiveSize: CGSize = CGSize(width: 44, height: 44),
        options: ValueSliderOptions = .defaultOptions
    ) {
        self.track = track
        self.thumb = thumb
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.options = options
    }
}

public extension HorizontalValueSliderStyle where Track == DefaultHorizontalValueTrack {
    init(
        thumb: Thumb,
        thumbSize: CGSize = CGSize(width: 27, height: 27),
        thumbInteractiveSize: CGSize = CGSize(width: 44, height: 44),
        options: ValueSliderOptions = .defaultOptions
    ) {
        self.track = DefaultHorizontalValueTrack()
        self.thumb = thumb
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.options = options
    }
}

public extension HorizontalValueSliderStyle where Thumb == DefaultThumb {
    init(
        track: Track,
        thumbSize: CGSize = CGSize(width: 27, height: 27),
        thumbInteractiveSize: CGSize = CGSize(width: 44, height: 44),
        options: ValueSliderOptions = .defaultOptions
    ) {
        self.track = track
        self.thumb = DefaultThumb()
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.options = options
    }
}

public extension HorizontalValueSliderStyle where Thumb == DefaultThumb, Track == DefaultHorizontalValueTrack {
    init(
        thumbSize: CGSize = CGSize(width: 27, height: 27),
        thumbInteractiveSize: CGSize = CGSize(width: 44, height: 44),
        options: ValueSliderOptions = .defaultOptions
    ) {
        self.track = DefaultHorizontalValueTrack()
        self.thumb = DefaultThumb()
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.options = options
    }
}

public struct DefaultHorizontalValueTrack: View {
    public init() {}
    public var body: some View {
        HorizontalTrack()
            .frame(height: 3)
            .background(Color.secondary.opacity(0.25))
            .cornerRadius(1.5)
    }
}

public struct ValueSliderOptions: OptionSet {
    public let rawValue: Int

    public static let interactiveTrack = ValueSliderOptions(rawValue: 1 << 0)
    public static let defaultOptions: ValueSliderOptions = []

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension EnvironmentValues {
    var trackValue: CGFloat {
        get {
            self[TrackValueKey.self]
        }
        set {
            self[TrackValueKey.self] = newValue
        }
    }
}

struct TrackValueKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 0.0
}

public struct ValueSliderStyleConfiguration {
    public let value: Binding<CGFloat>
    public let bounds: ClosedRange<CGFloat>
    public let step: CGFloat
    public let onEditingChanged: (Bool) -> Void
    public var dragOffset: Binding<CGFloat?>

    public init(
        value: Binding<CGFloat>,
        bounds: ClosedRange<CGFloat>,
        step: CGFloat,
        onEditingChanged: @escaping (Bool) -> Void,
        dragOffset: Binding<CGFloat?>
    ) {
        self.value = value
        self.bounds = bounds
        self.step = step
        self.onEditingChanged = onEditingChanged
        self.dragOffset = dragOffset
    }

    func with(dragOffset: Binding<CGFloat?>) -> Self {
        var mutSelf = self
        mutSelf.dragOffset = dragOffset
        return mutSelf
    }
}

public typealias HorizontalTrack = HorizontalValueTrack

public struct HorizontalValueTrack<ValueView: View, MaskView: View>: View {
    @Environment(\.trackValue) var value
    @Environment(\.valueTrackConfiguration) var configuration
    let view: AnyView
    let mask: AnyView

    public var body: some View {
        GeometryReader { geometry in
            self.view.accentColor(Color.accentColor)
                .mask(
                    ZStack {
                        self.mask
                            .frame(
                                width: distanceFrom(
                                    value: self.value,
                                    availableDistance: geometry.size.width,
                                    bounds: self.configuration.bounds,
                                    leadingOffset: self.configuration.leadingOffset,
                                    trailingOffset: self.configuration.trailingOffset
                                )
                            )
                    }
                    .frame(width: geometry.size.width, alignment: .leading)
                )
        }
    }
}

public extension HorizontalValueTrack {
    init(view: ValueView, mask: MaskView) {
        self.view = AnyView(view)
        self.mask = AnyView(mask)
    }
}

public extension HorizontalValueTrack where ValueView == DefaultHorizontalValueView {
    init(mask: MaskView) {
        self.init(view: DefaultHorizontalValueView(), mask: mask)
    }
}

public extension HorizontalValueTrack where MaskView == Capsule {
    init(view: ValueView) {
        self.init(view: view, mask: Capsule())
    }
}

public extension HorizontalValueTrack where ValueView == DefaultHorizontalValueView, MaskView == Capsule {
    init() {
        self.init(view: DefaultHorizontalValueView(), mask: Capsule())
    }
}

public struct DefaultHorizontalValueView: View {
    public var body: some View {
        Capsule()
            .foregroundColor(Color.accentColor)
            .frame(height: 3)
    }
}

public struct DefaultThumb: View {
    public init() {}
    public var body: some View {
        Capsule()
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1.5)
    }
}

public extension CGSize {
    static let defaultThumbSize: CGSize = .init(width: 27, height: 27)
    static let defaultThumbInteractiveSize: CGSize = .init(width: 44, height: 44)
}

public extension EnvironmentValues {
    var valueSliderStyle: AnyValueSliderStyle {
        get {
            self[ValueSliderStyleKey.self]
        }
        set {
            self[ValueSliderStyleKey.self] = newValue
        }
    }
}

public extension View {
    /// Sets the style for `ValueSlider` within the environment of `self`.
    @inlinable func valueSliderStyle(_ style: some ValueSliderStyle) -> some View {
        self.environment(\.valueSliderStyle, AnyValueSliderStyle(style))
    }
}

public struct AnyValueSliderStyle: ValueSliderStyle {
    private let styleMakeBody: (ValueSliderStyle.Configuration) -> AnyView

    public init(_ style: some ValueSliderStyle) {
        self.styleMakeBody = style.makeTypeErasedBody
    }

    public func makeBody(configuration: ValueSliderStyle.Configuration) -> AnyView {
        self.styleMakeBody(configuration)
    }
}

// MARK: - Non - public
private extension ValueSliderStyle {
    func makeTypeErasedBody(configuration: ValueSliderStyle.Configuration) -> AnyView {
        AnyView(makeBody(configuration: configuration))
    }
}

extension EnvironmentValues {
    var valueTrackConfiguration: ValueTrackConfiguration {
        get {
            self[ValueTrackConfigurationKey.self]
        }
        set {
            self[ValueTrackConfigurationKey.self] = newValue
        }
    }
}

struct ValueTrackConfigurationKey: EnvironmentKey {
    static let defaultValue: ValueTrackConfiguration = .defaultConfiguration
}

struct ValueTrackConfiguration {
    static let defaultConfiguration = ValueTrackConfiguration()

    let bounds: ClosedRange<CGFloat>
    let leadingOffset: CGFloat
    let trailingOffset: CGFloat

    init(bounds: ClosedRange<CGFloat> = 0.0 ... 1.0, leadingOffset: CGFloat = 0, trailingOffset: CGFloat = 0) {
        self.bounds = bounds
        self.leadingOffset = leadingOffset
        self.trailingOffset = trailingOffset
    }
}

extension ValueTrackConfiguration {
    init(bounds: ClosedRange<CGFloat> = 0.0 ... 1.0, offsets: CGFloat = 0) {
        self.bounds = bounds
        self.leadingOffset = offsets
        self.trailingOffset = offsets
    }
}

struct ValueSliderStyleKey: EnvironmentKey {
    static let defaultValue: AnyValueSliderStyle = .init(
        HorizontalValueSliderStyle()
    )
}

/// Calculates distance from zero in points
@inlinable func distanceFrom(
    value: CGFloat,
    availableDistance: CGFloat,
    bounds: ClosedRange<CGFloat> = 0.0 ... 1.0,
    leadingOffset: CGFloat = 0,
    trailingOffset: CGFloat = 0
) -> CGFloat {
    guard availableDistance > leadingOffset + trailingOffset else { return 0 }
    let boundsLenght = bounds.upperBound - bounds.lowerBound
    let relativeValue = (value - bounds.lowerBound) / boundsLenght
    let offset = (leadingOffset - ((leadingOffset + trailingOffset) * relativeValue))
    return offset + (availableDistance * relativeValue)
}

/// Calculates value for relative point in bounds with step.
/// Example: For relative value 0.5 in range 2.0..4.0 produces 3.0
@inlinable public func valueFrom(
    distance: CGFloat,
    availableDistance: CGFloat,
    bounds: ClosedRange<CGFloat> = 0.0 ... 1.0,
    step: CGFloat = 0.001,
    leadingOffset: CGFloat = 0,
    trailingOffset: CGFloat = 0
) -> CGFloat {
    let relativeValue = (distance - leadingOffset) / (availableDistance - (leadingOffset + trailingOffset))
    let newValue = bounds.lowerBound + (relativeValue * (bounds.upperBound - bounds.lowerBound))
    let steppedNewValue = (round(newValue / step) * step)
    let validatedValue = min(bounds.upperBound, max(bounds.lowerBound, steppedNewValue))
    return validatedValue
}

