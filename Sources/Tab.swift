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
		clibui.uiTabInsertAt(self.op, name, UInt(before), child.control)
	}

	func delete(index:Int) -> Void {
		clibui.uiTabDelete(self.op, UInt(index))
	}

	func numPages() -> Int {
		return Int(clibui.uiTabNumPages(self.op))
	}

	func getMargined(index:Int) -> Bool {
		return clibui.uiTabMargined(self.op, UInt(index)) == 1
	}

	func set(margined:Bool, index:Int) {
		clibui.uiTabSetMargined(self.op, UInt(index), margined ? 1 : 0)
	}

	func set(child:Control) -> Void {
		clibui.uiGroupSetChild(self.op, child.control)
	}

}
