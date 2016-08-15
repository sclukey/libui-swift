import clibui

class Tab: Control {
	let op:OpaquePointer;

	init() {
		self.op = clibui.uiNewTab();

		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(name:String, child:Control) -> Void {
		clibui.uiTabAppend(self.op, name, child.control)
	}

	func insert(name:String, before:Int, child:Control) -> Void {
		clibui.uiTabInsertAt(self.op, name, Int32(before), child.control)
	}

	func delete(index:Int) -> Void {
		clibui.uiTabDelete(self.op, Int32(index))
	}

	func numPages() -> Int {
		return Int(clibui.uiTabNumPages(self.op))
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
