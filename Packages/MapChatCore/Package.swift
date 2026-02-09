// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MapChatCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MapChatCore",
            targets: ["MapChatCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MapChatCore",
            dependencies: [],
            path: "Sources/MapChatCore"
        ),
        .testTarget(
            name: "MapChatCoreTests",
            dependencies: ["MapChatCore"]
        )
    ]
)
