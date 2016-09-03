import clibui

public class Entry: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	public init() {
		self.op = clibui.uiNewEntry()
		self.onChangedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public var text:String {
		get {
			return String(cString: clibui.uiEntryText(self.op))
		}
		set {
			clibui.uiEntrySetText(self.op, newValue)
		}
	}

	public var readonly:Bool {
		get {
			return clibui.uiEntryReadOnly(self.op) == 1
		}
		set {
			clibui.uiEntrySetReadOnly(self.op, newValue ? 1 : 0)
		}
	}

	public func on(changed: @escaping () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiEntryOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Entry>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
