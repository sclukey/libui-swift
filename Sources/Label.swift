import clibui

public class Label: Control {
	let op:OpaquePointer;

	public init(text:String) {
		self.op = clibui.uiNewLabel(text);

		super.init(UnsafeMutablePointer(self.op))
	}

	public var text:String {
		get {
			return String(cString: clibui.uiLabelText(self.op))
		}
		set {
			clibui.uiLabelSetText(self.op, newValue)
		}
	}

}
