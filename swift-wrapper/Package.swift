// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GPUPixelSwift",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15),
        .macCatalyst(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GPUPixelSwift",
            targets: ["GPUPixelSwift"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GPUPixelSwift",
            dependencies: [
                "GPUPixelObjCWrapper"
            ],
            path: "GPUPixelSwift",
            sources: [
                "Core/",
                "Filter/",
                "Source/",
                "Sink/",
                "FaceDetector/",
                "Utils/"
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath("../objc-wrapper"),
                .headerSearchPath("../objc-wrapper/GPUPixel"),
                .headerSearchPath("../include"),
                .headerSearchPath("../include/gpupixel"),
                .define("GPUPIXEL_SWIFT", .when(platforms: [.iOS, .macOS, .macCatalyst]))
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit"),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .macCatalyst])),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
                .linkedFramework("OpenGLES", .when(platforms: [.iOS, .macCatalyst])),
                .linkedFramework("OpenGL", .when(platforms: [.macOS])),
                .linkedFramework("AVFoundation")
            ]
        ),
        .systemLibrary(
            name: "GPUPixelObjCWrapper",
            path: "../objc-wrapper",
            pkgConfig: "gpupixel-objc-wrapper",
            providers: [
                .brew(["gpupixel"]),
                .apt(["libgpupixel-dev"])
            ]
        ),
        .testTarget(
            name: "GPUPixelSwiftTests",
            dependencies: ["GPUPixelSwift"],
            path: "Tests",
            sources: [
                "GPUPixelSwiftTests/"
            ]
        ),
    ],
    cxxLanguageStandard: .cxx17
)