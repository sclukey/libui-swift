import clibui

public class Box: Control {
	let op:OpaquePointer;

	public init(vertical:Bool) {
		if vertical {
			self.op = clibui.uiNewVerticalBox();
		} else {
			self.op = clibui.uiNewHorizontalBox();
		}
		
		super.init(c: UnsafeMutablePointer(self.op))
	}

	public func append(_ child:Control, stretchy:Bool=false) -> Void {
		clibui.uiBoxAppend(self.op, child.control, stretchy ? 1 : 0)
	}

	public func delete(index:Int) -> Void {
		clibui.uiBoxDelete(self.op, UInt(index))
	}

	public var padded:Bool {
		get {
			return clibui.uiBoxPadded(self.op) == 1
		}
		set {
			clibui.uiBoxSetPadded(self.op, newValue ? 1 : 0)
		}
	}

}
