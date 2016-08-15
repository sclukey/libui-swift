
.PHONY: all build clean test

all: clean build test

build:
	#swift build -Xlinker -t -Xlinker -v -Xlinker -L/Users/sclukey/Desktop/libui/build/out
	swift build -Xlinker -L/Users/sclukey/Desktop/libui/build-static/out

clean:
	swift build --clean

test: build
	#cp libui.a .build/debug
	swift test
