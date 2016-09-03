import clibui

public class EditableCombobox: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	public init() {
		self.op = clibui.uiNewEditableCombobox();
		self.onChangedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public func append(text:String) -> Void {
		clibui.uiEditableComboboxAppend(self.op, text)
	}

	public var text:String {
		get {
			return String(cString: clibui.uiEditableComboboxText(self.op))
		}
		set {
			clibui.uiEditableComboboxSetText(self.op, newValue)
		}
	}

	public func on(changed: @escaping () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiEditableComboboxOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<EditableCombobox>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
