// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-codable-advance",
    products: [
        .library(
            name: "CodableAdvance",
            targets: ["CodableAdvance"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/inekipelov/swift-collection-advance.git", from: "0.1.8")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .target(
            name: "CodableAdvance",
            dependencies: [
                .product(name: "CollectionAdvance", package: "swift-collection-advance")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "CodableAdvanceTests",
            dependencies: ["CodableAdvance"],
            path: "Tests"
        ),
    ]
)
