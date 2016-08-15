import clibui

enum EntryType {
	case Normal
	case Password
	case Search
}

class Entry: Control {
	let op:OpaquePointer;
	private var onChangedHandler: () -> Void

	init(type:EntryType=EntryType.Normal) {

		switch type {
			case .Normal:
				self.op = clibui.uiNewEntry()
			case .Password:
				self.op = clibui.uiNewPasswordEntry()
			case .Search:
				self.op = clibui.uiNewSearchEntry()
		}

		self.onChangedHandler = {}

		super.init(c: UnsafeMutablePointer(self.op))
	}

	var text:String {
		get {
			return String(cString: clibui.uiEntryText(self.op))
		}
		set {
			clibui.uiEntrySetText(self.op, newValue)
		}
	}

	var readonly:Bool {
		get {
			return clibui.uiEntryReadOnly(self.op) == 1
		}
		set {
			clibui.uiEntrySetReadOnly(self.op, newValue ? 1 : 0)
		}
	}

	func on(changed: () -> Void) -> Void {
		onChangedHandler = changed
		clibui.uiEntryOnChanged(self.op, { (w, d) -> Void in
			if let selfPointer = d {
				let myself = Unmanaged<Entry>.fromOpaque(selfPointer).takeUnretainedValue()

				myself.onChangedHandler()
			}
		}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(self).toOpaque()))		
	}

}
