import PackageDescription

let package = Package(
    name: "ui",
    dependencies: [
        .Package(url: "../clibui", Version(0,3,1)),
    ]
)
