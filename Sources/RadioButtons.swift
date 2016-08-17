import clibui

class RadioButtons: Control {
	let op:OpaquePointer;

	init() {
		self.op = clibui.uiNewRadioButtons();

		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(text:String) -> Void {
		clibui.uiRadioButtonsAppend(self.op, text)
	}

}
