// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleSnapshotTesting",
    platforms: [.iOS("16")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SimpleSnapshotTesting",
            targets: ["SimpleSnapshotTesting"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SimpleSnapshotTesting"),
        .testTarget(
            name: "SimpleSnapshotTestingTests",
            dependencies: ["SimpleSnapshotTesting"],
            resources: [.process("Fixtures/fixture_image_diff.png"),
                        .process("Fixtures/file with spaces.txt"),
                        .copy("Fixtures/folder with spaces/")]),
    ]
)
