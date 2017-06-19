import clibui

public class Combobox: Control {
	let op:OpaquePointer;
	private var onSelectedHandler: () -> Void

	public init() {
		self.op = clibui.uiNewCombobox();
		self.onSelectedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public func append(text:String) -> Void {
		clibui.uiComboboxAppend(self.op, text)
	}

	public var selected:Int32 {
		get {
			return Int32(clibui.uiComboboxSelected(self.op))
		}
		set {
			clibui.uiComboboxSetSelected(self.op, newValue)
		}
	}

	public func on(selected: @escaping () -> Void) -> Void {
		onSelectedHandler = selected
		clibui.uiComboboxOnSelected(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Combobox>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onSelectedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
