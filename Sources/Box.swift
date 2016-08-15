import clibui

class Box: Control {
	let op:OpaquePointer;

	init(vertical:Bool) {
		if vertical {
			self.op = clibui.uiNewVerticalBox();
		} else {
			self.op = clibui.uiNewHorizontalBox();
		}
		
		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(_ child:Control, stretchy:Bool=false) -> Void {
		clibui.uiBoxAppend(self.op, child.control, stretchy ? 1 : 0)
	}

	func delete(index:Int) -> Void {
		clibui.uiBoxDelete(self.op, Int32(index))
	}

	var padded:Bool {
		get {
			return clibui.uiBoxPadded(self.op) == 1
		}
		set {
			clibui.uiBoxSetPadded(self.op, newValue ? 1 : 0)
		}
	}

}
