import clibui

class Form: Control {
	let op:OpaquePointer;

	init() {
		self.op = clibui.uiNewForm();
		
		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(_ child:Control, label:String, stretchy:Bool=false) -> Void {
		clibui.uiFormAppend(self.op, label, child.control, stretchy ? 1 : 0)
	}

	func delete(index:Int) -> Void {
		clibui.uiFormDelete(self.op, Int32(index))
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
