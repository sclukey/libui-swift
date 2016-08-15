import clibui

class Separator: Control {
	let op:OpaquePointer;

	init(vertical:Bool) {
		if vertical {
			self.op = clibui.uiNewVerticalSeparator()
		} else {
			self.op = clibui.uiNewHorizontalSeparator()
		}

		super.init(c: UnsafeMutablePointer(self.op))
	}
	convenience init(horizontal:Bool) {
		self.init(vertical:!horizontal)
	}
}
