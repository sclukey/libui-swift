import clibui

public class Group: Control {
	let op:OpaquePointer;

	public init(title:String) {
		self.op = clibui.uiNewGroup(title);

		super.init(UnsafeMutablePointer(self.op))
	}

	public var title:String {
		set {
			clibui.uiGroupSetTitle(self.op, newValue)
		}
		get {
			return String(cString: clibui.uiGroupTitle(self.op))
		}
	}

	public var margined:Bool {
		set {
			clibui.uiGroupSetMargined(self.op, newValue ? 1 : 0)
		}
		get {
			return clibui.uiGroupMargined(self.op) == 1
		}
	}

	public func set(child:Control) -> Void {
		clibui.uiGroupSetChild(self.op, child.control)
	}

}
