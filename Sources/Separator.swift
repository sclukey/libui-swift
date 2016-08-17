import clibui

class Separator: Control {
	let op:OpaquePointer;

	init() {
		self.op = clibui.uiNewHorizontalSeparator()

		super.init(c: UnsafeMutablePointer(self.op))
	}
}
