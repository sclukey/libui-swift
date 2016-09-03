import clibui

public class MultilineEntry: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	public init(wrapping:Bool=true) {

		if wrapping {
			self.op = clibui.uiNewMultilineEntry()
		} else {
			self.op = clibui.uiNewNonWrappingMultilineEntry()
		}

		self.onChangedHandler = {}

		super.init(UnsafeMutablePointer(self.op))
	}

	public func append(text:String) -> Void {
		clibui.uiMultilineEntryAppend(self.op, text)
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
				let myself = Unmanaged<MultilineEntry>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
	}

}
