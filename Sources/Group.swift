import clibui

class Group: Control {
	let op:OpaquePointer;

	init(title:String) {
		self.op = clibui.uiNewGroup(title);

		super.init(c: UnsafeMutablePointer(self.op))
	}

	var title:String {
		set {
			clibui.uiGroupSetTitle(self.op, newValue)
		}
		get {
			return String(cString: clibui.uiGroupTitle(self.op))
		}
	}

	var margined:Bool {
		set {
			clibui.uiGroupSetMargined(self.op, newValue ? 1 : 0)
		}
		get {
			return clibui.uiGroupMargined(self.op) == 1
		}
	}

	func set(child:Control) -> Void {
		clibui.uiGroupSetChild(self.op, child.control)
	}

}
