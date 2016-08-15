import clibui

class Button: Control {
	let op:OpaquePointer;
	private var onClickedHandler: () -> Void

	init(text:String) {
		self.op = clibui.uiNewButton(text);
		self.onClickedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	var text:String {
		get {
			return String(cString: clibui.uiButtonText(self.op))
		}
		set {
			clibui.uiButtonSetText(self.op, newValue)
		}
	}

	func on(clicked: () -> Void) -> Void {
		onClickedHandler = clicked
		clibui.uiButtonOnClicked(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Button>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onClickedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

}
