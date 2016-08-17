import clibui

class ProgressBar: Control {
	let op:OpaquePointer;

	init() {
		self.op = clibui.uiNewProgressBar();

		super.init(c: UnsafeMutablePointer(self.op))
	}

	func set(value:Int) -> Void {
		clibui.uiProgressBarSetValue(self.op, Int32(value))
	}

}
