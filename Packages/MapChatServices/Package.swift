// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MapChatServices",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MapChatServices",
            targets: ["MapChatServices"]
        )
    ],
    dependencies: [
        .package(path: "../MapChatCore")
    ],
    targets: [
        .target(
            name: "MapChatServices",
            dependencies: ["MapChatCore"],
            path: "Sources/MapChatServices"
        ),
        .testTarget(
            name: "MapChatServicesTests",
            dependencies: ["MapChatServices"]
        )
    ]
)
