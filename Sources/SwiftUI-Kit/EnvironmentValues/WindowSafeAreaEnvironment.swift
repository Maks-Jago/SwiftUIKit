
import SwiftUI

#if os(iOS)
private struct WindowSafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.activeWindow?.safeAreaInsets ?? .zero).edgeInsets
    }
}

public extension EnvironmentValues {
    var windowSafeAreaInsets: EdgeInsets {
        self[WindowSafeAreaInsetsKey.self]
    }
}
#endif
