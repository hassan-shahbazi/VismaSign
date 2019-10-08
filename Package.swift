// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VismaSign",
    products: [
        .executable(name: "VismaSign", targets: ["VismaSign"]),
        .library(name: "VismaSignLibrary", targets: ["VismaSignLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "VismaSign",
            dependencies: ["VismaSignLibrary"]),
        .target(
            name: "VismaSignLibrary",
            dependencies: ["Cryptor"]),
        .testTarget(
            name: "VismaSignLibraryTests",
            dependencies: ["VismaSignLibrary"]),
    ]
)
