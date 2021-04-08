// swift-tools-version:5.2

import PackageDescription

let package = Package(
        name: "BidirectionalMap",
        products: [
            .library(
                    name: "BidirectionalMap",
                    targets: ["BidirectionalMap"]
            )
        ],
        targets: [
            .target(
                name: "BidirectionalMap",
                path: "Sources"
            )
        ],
        swiftLanguageVersions: [.v5]
)
