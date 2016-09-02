import clibui

public class Control {
	let control:UnsafeMutablePointer<clibui.uiControl>
	public init(_ c: UnsafeMutablePointer<clibui.uiControl>) {
		self.control = c
	}

	public func destroy() -> Void {
		clibui.uiControlDestroy(self.control)
	}

	public func handle() -> UnsafeMutablePointer<Void> {
		return UnsafeMutablePointer<Void>(bitPattern:clibui.uiControlHandle(self.control))!
	}

	public func topLevel() -> Int {
		return Int(clibui.uiControlToplevel(self.control))
	}

	public var visible:Bool {
		get {
			return clibui.uiControlVisible(self.control) == 1
		}
		set {
			if newValue {
				clibui.uiControlShow(self.control)
			} else {
				clibui.uiControlHide(self.control)
			}
		}
	}

	public func show() {
		clibui.uiControlShow(self.control)
	}

	public func hide() {
		clibui.uiControlHide(self.control)
	}

	public var enabled:Bool {
		get {
			return clibui.uiControlEnabled(self.control) == 1
		}
		set {
			if newValue {
				clibui.uiControlEnable(self.control)
			} else {
				clibui.uiControlDisable(self.control)
			}
		}
	}

	public func enable() -> Void {
		clibui.uiControlEnable(self.control)
	}

	public func disable() -> Void {
		clibui.uiControlDisable(self.control)
	}
}
