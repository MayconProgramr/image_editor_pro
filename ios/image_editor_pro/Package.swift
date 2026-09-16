// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "image_editor_pro",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "image-editor-pro", targets: ["image_editor_pro"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "image_editor_pro",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
