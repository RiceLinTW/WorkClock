// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let productName = "WorkClock"

enum FirstParty {
  enum WorkClockDatabase {
    static let name = "\(productName)Database"
    static var targets: [Target] {
      [
        .target(
          name: name,
          dependencies:
            ThirdParty.dependencies.targets,
          path: "Sources/\(productName)/\(name)"
        ),
        .testTarget(
          name: "\(name)Tests",
          dependencies: [
            .target(name: name)
          ],
          path: "Tests/\(productName)/\(name)Tests"
        )
      ]
    }
  }
}

enum ThirdParty {
  static var dependencies: DependencyWrapper {
    let packageName = "swift-dependencies"
    return DependencyWrapper(
      dependency: .package(
        url: "https://github.com/pointfreeco/\(packageName)",
        from: "1.9.2"
      ),
      targets: [
        .product(name: "Dependencies", package: packageName)
      ]
    )
  }
}

struct DependencyWrapper {
  let dependency: Package.Dependency
  let targets: [Target.Dependency]
}

let package = Package(
  name: productName,
  platforms: [
    .iOS(.v17),
    .macOS(.v14)
  ],
  products: [
    .library(
      name: productName,
      targets: [
        FirstParty.WorkClockDatabase.name
      ]
    )
  ],
  dependencies: [
    ThirdParty.dependencies.dependency
  ],
  targets:
  FirstParty.WorkClockDatabase.targets
)
