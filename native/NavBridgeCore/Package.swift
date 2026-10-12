// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "NavBridgeCore",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "NavBridgeCore", targets: ["NavBridgeCore"]),
  ],
  targets: [
    .target(name: "NavBridgeCore"),
    .testTarget(name: "NavBridgeCoreTests", dependencies: ["NavBridgeCore"]),
  ]
)
