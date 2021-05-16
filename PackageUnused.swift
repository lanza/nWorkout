// swift-tools-version:5.3

import PackageDescription

let packageName = "nworkout"  // <-- Change this to yours

let package = Package(
  name: "",
  // platforms: [.iOS("14.3")],
  products: [
    .library(name: packageName, targets: [packageName])
  ],
  targets: [
    .target(
      name: packageName,
      path: "source"
    )
  ]
)
