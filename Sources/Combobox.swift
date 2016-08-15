import clibui

class Combobox: Control {
	let op:OpaquePointer;
	private var onSelectedHandler: () -> Void

	init() {
		self.op = clibui.uiNewCombobox();
		self.onSelectedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(text:String) -> Void {
		clibui.uiComboboxAppend(self.op, text)
	}

	var selected:Int {
		get {
			return Int(clibui.uiComboboxSelected(self.op))
		}
		set {
			clibui.uiComboboxSetSelected(self.op, Int32(newValue))
		}
	}

	func on(selected: () -> Void) -> Void {
		onSelectedHandler = selected
		clibui.uiComboboxOnSelected(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Combobox>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onSelectedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

}
