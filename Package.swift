// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SosuzagramIOSCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "SosuzagramIOSCore", targets: ["SosuzagramIOSCore"])],
    targets: [
        .target(name: "SosuzagramIOSCore"),
        .testTarget(name: "SosuzagramIOSCoreTests", dependencies: ["SosuzagramIOSCore"])
    ]
)
