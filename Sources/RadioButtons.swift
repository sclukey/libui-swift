import clibui

public class RadioButtons: Control {
	let op:OpaquePointer;

	public init() {
		self.op = clibui.uiNewRadioButtons();

		super.init(c: UnsafeMutablePointer(self.op))
	}

	public func append(text:String) -> Void {
		clibui.uiRadioButtonsAppend(self.op, text)
	}

}
