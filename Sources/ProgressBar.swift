import clibui

class ProgressBar: Control {
	let op:OpaquePointer;

	init() {
		self.op = clibui.uiNewProgressBar();

		super.init(c: UnsafeMutablePointer(self.op))
	}

	var value:Int {
		get {
			return Int(clibui.uiProgressBarValue(self.op))
		}
		set {
			clibui.uiProgressBarSetValue(self.op, Int32(newValue))
		}
	}

}
