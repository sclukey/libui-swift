
.PHONY: all build clean

all: clean build

build:
	swift build -Xlinker -L/opt/local/lib

clean:
	swift build --clean
