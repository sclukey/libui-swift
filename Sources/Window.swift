import clibui

public class Window: Control {
	let op:OpaquePointer;
	private var onCloseHandler: () -> Int

	public init(title:String, width:Int32, height:Int32, withMenu:Bool = false) {
		self.op = clibui.uiNewWindow(title, width, height, withMenu ? 1 : 0);
		self.onCloseHandler = { return 0 }

		super.init(UnsafeMutablePointer(self.op))
	}

	public func on(closing: @escaping () -> Int) {
		onCloseHandler = closing
		clibui.uiWindowOnClosing(self.op, { (w, d) -> Int32 in
			if let windowPointer = d {
				let window = Unmanaged<Window>.fromOpaque(windowPointer).takeUnretainedValue()

				return Int32(window.onCloseHandler())
			}

			return -1
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

	public var title:String {
		set {
			clibui.uiWindowSetTitle(self.op, newValue)
		}
		get {
			return String(cString: clibui.uiWindowTitle(self.op))
		}
	}

	public var margined:Bool {
		set {
			clibui.uiWindowSetMargined(self.op, newValue ? 1 : 0)
		}
		get {
			return clibui.uiWindowMargined(self.op) == 1
		}
	}

	public func set(child:Control) -> Void {
		uiWindowSetChild(self.op, child.control)
	}
}
