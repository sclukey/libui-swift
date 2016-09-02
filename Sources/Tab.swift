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

	public func insert(name:String, before:Int, child:Control) -> Void {
		clibui.uiTabInsertAt(self.op, name, UInt(before), child.control)
	}

	public func delete(index:Int) -> Void {
		clibui.uiTabDelete(self.op, UInt(index))
	}

	public func numPages() -> Int {
		return Int(clibui.uiTabNumPages(self.op))
	}

	public func getMargined(index:Int) -> Bool {
		return clibui.uiTabMargined(self.op, UInt(index)) == 1
	}

	public func set(margined:Bool, index:Int) {
		clibui.uiTabSetMargined(self.op, UInt(index), margined ? 1 : 0)
	}

	public func set(child:Control) -> Void {
		clibui.uiGroupSetChild(self.op, child.control)
	}

}
