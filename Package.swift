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
        .library(name: "CodableRouting", targets: ["CodableRouting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swhitty/FlyingFox.git", .upToNextMajor(from: "0.10.0")),
    ],
    targets: [

        .target(name: "Backend"),

        .executableTarget(
            name: "BackendFF",
            dependencies: [
                "Backend",
                .product(name: "FlyingFox", package: "FlyingFox"),
            ]),

        .testTarget(
            name: "BackendTests",
            dependencies: [
                "Backend"
            ]),

        .target(name: "CodableRouting"),

            .testTarget(
                name: "CodableRoutingTests",
                dependencies: [
                    "CodableRouting"
                ]),
    ]
)
