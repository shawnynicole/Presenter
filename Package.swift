// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presenter",
    platforms: [
        //.macOS(.v10_15),
        .iOS(.v14),
        //.tvOS(.v9),
        //.watchOS(.v2)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Presenter",
            targets: ["Presenter"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Border", url: "https://github.com/shawnynicole/Border", from: "1.3.0"),
        .package(name: "Colors", url: "https://github.com/shawnynicole/Colors", from: "1.0.0"),
        .package(name: "Print", url: "https://github.com/shawnynicole/Print", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Presenter",
            dependencies: [
                .product(name: "Border", package: "Border"),
                .product(name: "Colors", package: "Colors"),
                .product(name: "Print", package: "Print"),
            ]),
        .testTarget(
            name: "PresenterTests",
            dependencies: ["Presenter"]),
    ]
)
