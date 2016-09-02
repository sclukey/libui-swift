import clibui

public class Separator: Control {
	let op:OpaquePointer;

	public init() {
		self.op = clibui.uiNewHorizontalSeparator()

		super.init(UnsafeMutablePointer(self.op))
	}
}
