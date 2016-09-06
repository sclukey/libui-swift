# libui-swift

This is an object oriented (and much more "Swifty") wrapper for [clibui](https://github.com/sclukey/clibui), which provides Swift bindings for [libui](https://github.com/andlabs/libui).

## Swift Version

This package is tested with Swift 3, earlier versions of Swift will be ignored completely.

## libui Version

Currently this package is built to support libui version **Alpha3.1**. I intend to update this for each release version, but between releases libui's HEAD may not be supported.

| libui-swift Tag | libui Version |
|-----------------|---------------|
| 1.0.x           | Alpha3.1      |

## Usage

To use this you need first to have a compiled version of libui. You can either [download the supported release](https://github.com/andlabs/libui/releases/tag/alpha3.1) or compile libui yourself. Note that if you compile yourself you should take care to use the same version that this package expects — the libui API is currently very unstable.

Then, add the dependency to this module in your `Package.swift`:

```swift
.Package(url: "https://github.com/sclukey/libui-swift.git", majorVersion: 1)
```

Finally, when compiling a project that uses this package you need give Swift the location of the compiled library and the `ui.h` header file. Assuming you extracted the release package to `/path/to/libui`, you are on 64-bit Linux, and you want a static build, then you would need to use

```
swift build -Xswiftc -I/path/to/libui/src -Xlinker -L/path/to/libui/linux_amd64/static
```

## Examples

There are example programs available [here](https://github.com/sclukey/libui-swift-examples).
