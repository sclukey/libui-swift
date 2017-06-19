import clibui

public class Tab: Control {
	let op:OpaquePointer;

	public init() {
		self.op = clibui.uiNewTab();

		super.init(UnsafeMutablePointer(self.op))
	}

	public func append(name:String, child:Control) -> Void {
		clibui.uiTabAppend(self.op, name, child.control)
	}

	public func insert(name:String, before:Int32, child:Control) -> Void {
		clibui.uiTabInsertAt(self.op, name, before, child.control)
	}

	public func delete(index:Int32) -> Void {
		clibui.uiTabDelete(self.op, index)
	}

	public func numPages() -> Int32 {
		return clibui.uiTabNumPages(self.op)
	}

	public func getMargined(index:Int32) -> Bool {
		return clibui.uiTabMargined(self.op, index) == 1
	}

	public func set(margined:Bool, index:Int32) {
		clibui.uiTabSetMargined(self.op, index, margined ? 1 : 0)
	}

	public func set(child:Control) -> Void {
		clibui.uiGroupSetChild(self.op, child.control)
	}

}
