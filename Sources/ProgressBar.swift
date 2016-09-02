import clibui

public class ProgressBar: Control {
	let op:OpaquePointer;

	public init() {
		self.op = clibui.uiNewProgressBar();

		super.init(UnsafeMutablePointer(self.op))
	}

	public func set(value:Int) -> Void {
		clibui.uiProgressBarSetValue(self.op, Int32(value))
	}

}
