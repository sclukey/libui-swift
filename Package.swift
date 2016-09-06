import PackageDescription

let package = Package(
    name: "ui",
    dependencies: [
        .Package(url: "https://github.com/sclukey/clibui.git", majorVersion:1),
    ]
)
