import PackageDescription

let package = Package(
    name: "ui",
    dependencies: [
        .Package(url: "../clibui", majorVersion:1),
    ]
)
