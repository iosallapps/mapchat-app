// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MapChatDesign",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MapChatDesign",
            targets: ["MapChatDesign"]
        )
    ],
    dependencies: [
        .package(path: "../MapChatCore")
    ],
    targets: [
        .target(
            name: "MapChatDesign",
            dependencies: ["MapChatCore"],
            path: "Sources/MapChatDesign"
        ),
        .testTarget(
            name: "MapChatDesignTests",
            dependencies: ["MapChatDesign"]
        )
    ]
)
