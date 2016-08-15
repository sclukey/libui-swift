import clibui

class Checkbox: Control {
	let op:OpaquePointer;
	private var onToggledHandler: () -> Void

	init(text:String) {
		self.op = clibui.uiNewCheckbox(text);
		self.onToggledHandler = {}
		
		super.init(c: UnsafeMutablePointer(self.op))
	}

	func on(toggled: () -> Void) -> Void {
		onToggledHandler = toggled
		clibui.uiCheckboxOnToggled(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Checkbox>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onToggledHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

	var text:String {
		get {
			return String(cString: clibui.uiCheckboxText(self.op))
		}
		set {
			clibui.uiCheckboxSetText(self.op, newValue)
		}
	}

	var checked:Bool {
		set {
			clibui.uiCheckboxSetChecked(self.op, newValue ? 1 : 0)
		}
		get {
			return clibui.uiCheckboxChecked(self.op) == 1
		}
	}
}
