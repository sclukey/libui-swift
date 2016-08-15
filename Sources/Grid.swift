import clibui

class Grid: Control {
	let op:OpaquePointer;

	init() {
		self.op = clibui.uiNewGrid();
		
		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(_ child:Control, left:Int, top:Int, xspan:Int, yspan:Int, hexpand:Bool, halign:Align, vexpand:Bool, valign:Align) -> Void {
		clibui.uiGridAppend(self.op, child.control, Int32(left), Int32(top), Int32(xspan), Int32(yspan), hexpand ? 1 : 0, convert(align:halign), vexpand ? 1 : 0, convert(align:valign))
	}

	func insert(child:Control, anchor:Control, at:At, xspan:Int, yspan:Int, hexpand:Bool, halign:Align, vexpand:Bool, valign:Align) -> Void {
		clibui.uiGridInsertAt(self.op, child.control, anchor.control, convert(at:at), Int32(xspan), Int32(yspan), hexpand ? 1 : 0, convert(align:halign), vexpand ? 1 : 0, convert(align:valign))
	}

	var padded:Bool {
		get {
			return clibui.uiFormPadded(self.op) == 1
		}
		set {
			clibui.uiFormSetPadded(self.op, newValue ? 1 : 0)
		}
	}

}
