import clibui

public class ColorButton: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	public init() {
		self.op = clibui.uiNewColorButton()
		self.onChangedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public var color:(red:Double, green:Double, blue:Double, alpha:Double) {
		get {
			var red:Double = -1
			var green:Double = -1
			var blue:Double = -1
			var alpha:Double = -1
			clibui.uiColorButtonColor(self.op, &red, &green, &blue, &alpha)

			return (red, green, blue, alpha)
		}
		set {
			let (red, green, blue, alpha) = newValue
			clibui.uiColorButtonSetColor(self.op, red, green, blue, alpha)
		}
	}

	public func on(changed: @escaping () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiColorButtonOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<ColorButton>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
