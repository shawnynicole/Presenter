# Presenter

**Presenter** makes ease of presenting views such as drop downs and modal views onto a presenter view.

<p align="center">
    <a href="#requirements">Requirements</a> • <a href="#installation">Installation</a> • <a href="#usage">Usage</a> • <a href="#author">Author</a> • <a href="#license-mit">License</a>
</p>

## Requirements

- Xcode 10.2+
- Swift 5.0+

## Installation

#### Swift Package Manager
You can use [The Swift Package Manager](https://swift.org/package-manager) to install `Presenter` by adding the proper description to your `Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/shawnynicole/Presenter.git", from: "1.0.0")
    ]
)
```
For more information on [Swift Package Manager](https://swift.org/package-manager), checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

#### Manually

[Download](https://github.com/shawnynicole/Presenter/archive/master.zip) the project and copy the `Presenter` folder into your project to use it in.

## Usage

```swift
import SwiftUI
import Presenter

// DropDown and Modal both use Presentation.
// Presentation is used to make custom presenting styles (i.e. Modal and DropDown), and can be used to make additional ones.
// It returns the GeometryProxy for its label view and the GeometryProxy for its Presenter view to its content view for custom offset/frame adjustments.
// Generally, the label view is a button/tapGesture that toggles isPresenting.
// To present a Presentation view (i.e. DropDown, Modal, etc.), .presenter() must be attached on a parent view.
// It is recommended (but not required) to attach a presenter to a root view (i.e. navigation root view) or main parent view (i.e. detail view).

// Attaching a presenter to a root view
NavigationView {
    VStack {
        ...
    }
    .presenter()
}

// Modal views
// If the size or padding causes the modal view to extend off the screen, its size and/or offset are adjusted to fit on the screen.

// Padding is an optional paramater. Default is 0.
Modal(isPresenting: $isPresenting, size: CGSize(width: 300, height: 400), padding: 0) {
    label(isPresenting: $isPresenting)
} presents: {
    modalPresentation(isPresenting: $isPresenting)
}

// Padding is an optional paramater. Default is 50. 
Modal(isPresenting: $isPresenting, padding: 100) {
    label(isPresenting: $isPresenting)
} presents: {
    modalPresentation(isPresenting: $isPresenting)
}

// DropDown views
// If the size or position causes the drop down view to extend off the screen, its size and/or offset are adjusted to fit on the screen.

// Position is optional. Default is labelWidth, which makes makes the presentation view the same width as its label view.
// DropDownHorizontalPosition.center, .leading, and .trailing accept a width parameter for the presentation view. 
// This allows a custom width for the presentation view, then the presentation view is aligned accordingly to the label view.
// DropDown also accepts optional minHeight and maxHeight parameters

// Uses default .labelWidth position
DropDown(isPresenting: $isPresenting, maxHeight: 200) {
    label(isPresenting: $isPresenting, selection: $selection)
} presents: {
    dropDownPresentation(isPresenting: $isPresenting, selection: $selection)
}

// Uses a custom alignment and width
DropDown(isPresenting: $isPresenting, position: .leading(width: 500)) {
    label(isPresenting: $isPresenting, selection: $selection)
} presents: {
    dropDownPresentation(isPresenting: $isPresenting, selection: $selection)
}
```

## Author

shawnynicole

## License

**Presenter** is available under the MIT license. See the LICENSE file for more info.
