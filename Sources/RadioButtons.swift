import clibui

class RadioButtons: Control {
	let op:OpaquePointer;
	private var onSelectedHandler: () -> Void

	init() {
		self.op = clibui.uiNewRadioButtons();
		self.onSelectedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(text:String) -> Void {
		clibui.uiRadioButtonsAppend(self.op, text)
	}

	var selected:Int {
		get {
			return Int(clibui.uiRadioButtonsSelected(self.op))
		}
		set {
			clibui.uiRadioButtonsSetSelected(self.op, Int32(newValue))
		}
	}

	func on(selected: () -> Void) -> Void {
		onSelectedHandler = selected
		clibui.uiRadioButtonsOnSelected(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<RadioButtons>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onSelectedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

}
