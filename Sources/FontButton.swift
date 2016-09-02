import clibui

public class FontButton: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	public init() {
		self.op = clibui.uiNewFontButton()
		self.onChangedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	public func getFont() -> DrawTextFont {
		let cFont = clibui.uiFontButtonFont(self.op)

		// I'm not sure how `cFont == nil` would ever happen since the value
		// comes from a GUI picker that has no 'none' option. That said I am OK
		// with this function throwing an error if `cFont!` fails.
		return DrawTextFont(cFont!)
	}

	public func on(changed: () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiFontButtonOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<FontButton>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))
	}

}
