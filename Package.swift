// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "AyuGramIOSCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AyuGramIOSCore", targets: ["AyuGramIOSCore"])
    ],
    targets: [
        .target(name: "AyuGramIOSCore"),
        .testTarget(name: "AyuGramIOSCoreTests", dependencies: ["AyuGramIOSCore"])
    ]
)
