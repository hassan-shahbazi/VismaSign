// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VismaSign",
    products: [
        .executable(name: "VismaSign", targets: ["VismaSign"]),
        .library(name: "VismaSignClient", targets: ["VismaSignClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "VismaSign",
            dependencies: ["VismaSignClient"]),
        .target(
            name: "VismaSignClient",
            dependencies: ["Cryptor"]),
        .testTarget(
            name: "VismaSignClientTests",
            dependencies: ["VismaSignClient"]),
    ]
)
