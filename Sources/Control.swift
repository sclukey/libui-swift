import clibui

/// A user interface control
public class Control {
	/// Pointer to the C-level control structure
	let control:UnsafeMutablePointer<clibui.uiControl>

	/**
	    Creates a Control wrapper from a pointer to the C-level structure
	*/
	public init(_ c: UnsafeMutablePointer<clibui.uiControl>) {
		self.control = c
	}

	/**
	    Free the C-level control's memory
	*/
	public func destroy() -> Void {
		clibui.uiControlDestroy(self.control)
	}

	/**
	    Get a pointer to the OS- and implementation-specific control
	*/
	public func handle() -> UnsafeMutableRawPointer {
		return UnsafeMutableRawPointer(bitPattern:clibui.uiControlHandle(self.control))!
	}

	/**
	    Honestly not sure what this function does and I don't feel like
	    spending the time to figure it out. Perhaps I'll just wait for LibUI to
	    be documented then update this.
	*/
	public func topLevel() -> Int {
		return Int(clibui.uiControlToplevel(self.control))
	}

	/**
	    The visibility of the control
	*/
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

	/**
	    Show the control
	*/
	public func show() {
		clibui.uiControlShow(self.control)
	}

	/**
	    Hide the control
	*/
	public func hide() {
		clibui.uiControlHide(self.control)
	}

	/**
	    The enabled state of the control
	*/
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

	/**
	    Enable the control
	*/
	public func enable() -> Void {
		clibui.uiControlEnable(self.control)
	}

	/**
	    Disable the control
	*/
	public func disable() -> Void {
		clibui.uiControlDisable(self.control)
	}
}
