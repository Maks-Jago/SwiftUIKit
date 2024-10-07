# SwiftUIKit

SwiftUIKit is a collection of useful extensions and utilities for SwiftUI. This library enhances SwiftUI development by providing a variety of view modifiers, UIKit wrappers, and additional functionalities. It includes components for handling UI appearance, user interactions, and more.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Extensions and Components](#extensions-and-components)
  - [View Extensions](#view-extensions)
  - [UIKit Wrappers](#uikit-wrappers)
  - [Modifiers](#modifiers)
  - [Other Components](#other-components)
  - [Additional UIKit Extensions](#additional-uikit-extensions)
- [License](#license)

## Installation

To use `SwiftUIKit` in your project, copy the source files directly into your project, or use Swift Package Manager.

## Usage

After installation, import the library into your SwiftUI views:

```swift
import SwiftUI
import SwiftUI_Kit
```

You can then use the provided extensions, components, and modifiers to enhance your views. Each extension and utility included in this library extends existing SwiftUI types or provides new functionality to make your code more concise and expressive. Refer to the extensions and components listed below for details on usage.

## List of Extensions and Components

### View Extensions

- **`cornerRadius(_:corners:)`**
  Applies rounded corners to specific corners of a view.

- **`embedInNavigationView()`**
  Embeds the view in a `NavigationView`.

- **`embedInScrollView(alignment:)`**
  Embeds the view in a `ScrollView`.

- **`eraseToAnyView()`**  
  Converts the view to `AnyView`.

- **`loaderSheet(isPresented:title:font:indicatorColor:titleColor:backgroundColor:)`**  
  Displays a loading sheet with a customizable activity indicator.

- **`navigationBarColor(_:shadowColor:titleColor:)`**  
  Modifies the navigation bar’s color, shadow, and title color.

- **`addVisualEffectAsBackground(effect:)`**  
  Adds a `UIVisualEffect` as the background of the view.

- **`pullToRefresh(isRefreshing:)`**  
  Adds a pull-to-refresh capability to the view.

- **`allowSwipeToDismiss(_:)`**  
  Allows swipe-to-dismiss behavior on the view.

- **`uiKitOnAppear(_:)`**  
  Executes a closure when the view appears using UIKit’s `viewDidAppear`.

### UIKit Wrappers

- **`ActivityIndicator`**  
  A SwiftUI wrapper for `UIActivityIndicatorView`.

- **`MailView`**  
  A SwiftUI wrapper for `MFMailComposeViewController`.

- **`PageControl`**  
  A SwiftUI wrapper for `UIPageControl`.

- **`PagerView`**  
  A view that displays a paginated, swipeable collection of pages.

- **`PencilKitView`**  
  A SwiftUI wrapper for `PKCanvasView`, allowing users to draw using PencilKit.

- **`SafariView`**  
  A SwiftUI wrapper for `SFSafariViewController`.

- **`ShareSheet`**  
  A SwiftUI wrapper for `UIActivityViewController`.

- **`VideoPlayerView`**  
  A SwiftUI wrapper for `AVPlayerViewController`.

### Modifiers

- **`AnimatedRedactedModifier`**  
  Applies an animated redacted (shimmer) effect to a view.

- **`LoaderSheet`**  
  Displays a loading sheet with a customizable activity indicator.

- **`NavigationControllerConfigurator`**  
  Configures the navigation controller for the current view.

- **`RoundedCorner`**  
  A shape that rounds specific corners of a rectangle.

### Other Components

- **`IfLetView`**  
  A view that conditionally displays content based on the presence of an optional value.

- **`IfLetViewPlaceholder`**  
  A view that conditionally displays content with a placeholder for the `nil` case.

- **`UIKitAppear`**  
  Provides a way to execute a closure when the view appears using UIKit’s `viewDidAppear`.

### Additional UIKit Extensions

- **`EdgeInsets`**  
  Provides utility methods to create `EdgeInsets`.

- **`UIApplication`**  
  Retrieves the active window and ends editing.

- **`UIFont`**  
  Calculates the height of a text using the font.

- **`UIColor`**  
  Converts `Color` to `UIColor`.

- **`UIDevice`**  
  Utility properties for checking device types (e.g., iPhone SE, iPhone 8).

- **`PreviewDevice`**  
  Utility properties for common iOS devices.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
