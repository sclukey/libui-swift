import clibui

public class Checkbox: Control {
	let op:OpaquePointer;
	private var onToggledHandler: () -> Void

	public init(text:String) {
		self.op = clibui.uiNewCheckbox(text);
		self.onToggledHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public func on(toggled: @escaping () -> Void) -> Void {
		onToggledHandler = toggled
		clibui.uiCheckboxOnToggled(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Checkbox>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onToggledHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

	public var text:String {
		get {
			return String(cString: clibui.uiCheckboxText(self.op))
		}
		set {
			clibui.uiCheckboxSetText(self.op, newValue)
		}
	}

	public var checked:Bool {
		set {
			clibui.uiCheckboxSetChecked(self.op, newValue ? 1 : 0)
		}
		get {
			return clibui.uiCheckboxChecked(self.op) == 1
		}
	}
}
