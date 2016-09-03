import clibui

public class MenuItem {
	let op:OpaquePointer;
	private var onClickedHandler: () -> Void

	public init(_ item:OpaquePointer) {
		self.op = item
		self.onClickedHandler = {}
	}

	public func on(clicked: @escaping () -> Void) -> Void {
		onClickedHandler = clicked
		clibui.uiMenuItemOnClicked(self.op, { (s, w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<MenuItem>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onClickedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

	public func enable() -> Void {
		clibui.uiMenuItemEnable(self.op)
	}

	public func disable() -> Void {
		clibui.uiMenuItemDisable(self.op)
	}

	public var checked:Bool {
		set {
			clibui.uiMenuItemSetChecked(self.op, newValue ? 1 : 0)
		}
		get {
			return clibui.uiMenuItemChecked(self.op) == 1
		}
	}
}
