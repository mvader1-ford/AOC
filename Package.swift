// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Advent of Code",
    platforms: [.macOS(.v11)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "AOCCore", targets: ["AOCCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "swift-collections", url: "git@github.com:apple/swift-collections.git", from: "1.0.2"),
        .package(name: "swift-algorithms", url: "git@github.com:apple/swift-algorithms.git", from: "0.0.2"),
        .package(name: "MathParser", url: "https://github.com/davedelong/DDMathParser.git", .branch("master"))
    ],
    targets: [
   
        .target(name: "AOCCore", dependencies: [
            .product(name: "Algorithms", package: "swift-algorithms"),
            .product(name: "Collections", package: "swift-collections")
        ]),
        
        .testTarget(name: "AOCTests", dependencies: ["AOC"]),
    ]
)
