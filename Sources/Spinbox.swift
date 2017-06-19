import clibui

public class Spinbox: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	public init(min:Int32, max:Int32) {
		self.op = clibui.uiNewSpinbox(min, max);
		self.onChangedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public var value:Int32 {
		get {
			return Int32(clibui.uiSpinboxValue(self.op))
		}
		set {
			clibui.uiSpinboxSetValue(self.op, newValue)
		}
	}

	public func on(changed: @escaping () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiSpinboxOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Spinbox>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
