import clibui

class MenuItem {
	let op:OpaquePointer;
	private var onClickedHandler: () -> Void

	init(_ item:OpaquePointer) {
		self.op = item
		self.onClickedHandler = {}
	}

	func on(clicked: () -> Void) -> Void {
		onClickedHandler = clicked
		clibui.uiMenuItemOnClicked(self.op, { (s, w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<MenuItem>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onClickedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

	func enable() -> Void {
		clibui.uiMenuItemEnable(self.op)
	}

	func disable() -> Void {
		clibui.uiMenuItemDisable(self.op)
	}

	var checked:Bool {
		set {
			clibui.uiMenuItemSetChecked(self.op, newValue ? 1 : 0)
		}
		get {
			return clibui.uiMenuItemChecked(self.op) == 1
		}
	}
}
