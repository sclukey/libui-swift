import clibui

public class Button: Control {
	let op:OpaquePointer;
	private var onClickedHandler: () -> Void

	public init(text:String) {
		self.op = clibui.uiNewButton(text);
		self.onClickedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public var text:String {
		get {
			return String(cString: clibui.uiButtonText(self.op))
		}
		set {
			clibui.uiButtonSetText(self.op, newValue)
		}
	}

	public func on(clicked: @escaping () -> Void) -> Void {
		onClickedHandler = clicked
		clibui.uiButtonOnClicked(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Button>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onClickedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
