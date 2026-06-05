// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SosuzagramIOSCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "SosuzagramIOSCore", targets: ["SosuzagramIOSCore"])],
    targets: [
        .target(name: "SosuzagramIOSCore", path: "Sources/AyuGramIOSCore"),
        .testTarget(name: "SosuzagramIOSCoreTests", dependencies: ["SosuzagramIOSCore"], path: "Tests/SosuzagramIOSCoreTests")
    ]
)
