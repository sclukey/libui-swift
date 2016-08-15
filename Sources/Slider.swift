import clibui

class Slider: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	init(min:Int, max:Int) {
		self.op = clibui.uiNewSlider(Int32(min), Int32(max));
		self.onChangedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	var value:Int {
		get {
			return Int(clibui.uiSliderValue(self.op))
		}
		set {
			clibui.uiSliderSetValue(self.op, Int32(newValue))
		}
	}

	func on(changed: () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiSliderOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Slider>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

}
