// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SosuzagramIOSCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "SosuzagramIOSCore", targets: ["SosuzagramIOSCore"])],
    targets: [
        .target(
            name: "SosuzagramIOSCore",
            path: "Sources/SosuzagramIOSCore",
            sources: [
                // Core pure-Swift files (no UIKit dependency)
                "MessageModels.swift",
                "MessageHistoryService.swift",
                "LocalHistoryStore.swift",
                "InMemoryLocalHistoryStore.swift",
                "PrivacySettings.swift",
                // UIKit-dependent files excluded from SPM; compiled only via Bazel for iOS
                // "SosuzagramSettingsController.swift",
                // "SosuzagramServerStatus.swift",
                // "EmbeddedPlugins.swift",
            ]
        ),
        .testTarget(name: "SosuzagramIOSCoreTests", dependencies: ["SosuzagramIOSCore"], path: "Tests/SosuzagramIOSCoreTests")
    ]
)
