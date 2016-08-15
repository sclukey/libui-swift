import clibui

public class App {
	public init() {
		var options = clibui.uiInitOptions()
		_ = clibui.uiInit(&options)
	}

	// Leave this out until the uiUninit() function doesn't crash on OS X anymore
	// deinit {
	// 	clibui.uiUninit()
	// }

	public func main() -> Void {
		clibui.uiMain()
	}

	public func quit() -> Void {
		clibui.uiQuit()
	}
}
