// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Backend",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "Backend", targets: ["Backend"]),
    ],
    targets: [
        .target(name: "Backend"),
        .testTarget(name: "BackendTests", dependencies: ["Backend"]),
    ]
)
