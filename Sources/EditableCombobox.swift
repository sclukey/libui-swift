import clibui

class EditableCombobox: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	init() {
		self.op = clibui.uiNewEditableCombobox();
		self.onChangedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	func append(text:String) -> Void {
		clibui.uiEditableComboboxAppend(self.op, text)
	}

	var text:String {
		get {
			return String(cString: clibui.uiEditableComboboxText(self.op))
		}
		set {
			clibui.uiEditableComboboxSetText(self.op, newValue)
		}
	}

	func on(changed: () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiEditableComboboxOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<EditableCombobox>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

}
