import clibui

public class Slider: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	public init(min:Int32, max:Int32) {
		self.op = clibui.uiNewSlider(min, max);
		self.onChangedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public var value:Int32 {
		get {
			return Int32(clibui.uiSliderValue(self.op))
		}
		set {
			clibui.uiSliderSetValue(self.op, newValue)
		}
	}

	public func on(changed: @escaping () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiSliderOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Slider>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
