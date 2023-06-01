
#if canImport(UIKit)
import UIKit

public extension UIApplication {
    var activeWindow: UIWindow? {
        var scenes = connectedScenes
            .filter { $0.activationState == .foregroundActive }

        if scenes.isEmpty {
            scenes = connectedScenes
        }

        return scenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
