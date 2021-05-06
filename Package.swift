// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "observ",
    platforms: [
            .macOS(.v10_13)
        ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.3.0"),
        .package(url: "https://github.com/kiliankoe/CLISpinner", from: "0.4.0")
    ],
    targets: [
        .target(
            name: "observ",
            dependencies: ["ShellOut", "SwiftCLI", "Files", "CLISpinner"]),
        .testTarget(
            name: "observTests",
            dependencies: ["observ"]),
    ]
)
