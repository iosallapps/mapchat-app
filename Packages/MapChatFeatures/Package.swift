// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MapChatFeatures",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MapChatFeatures",
            targets: ["MapChatFeatures"]
        )
    ],
    dependencies: [
        .package(path: "../MapChatCore"),
        .package(path: "../MapChatDesign"),
        .package(path: "../MapChatServices")
    ],
    targets: [
        .target(
            name: "MapChatFeatures",
            dependencies: [
                "MapChatCore",
                "MapChatDesign",
                "MapChatServices"
            ],
            path: "Sources/MapChatFeatures"
        ),
        .testTarget(
            name: "MapChatFeaturesTests",
            dependencies: ["MapChatFeatures"]
        )
    ]
)
