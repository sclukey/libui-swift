#if os(OSX)
import AppKit
#endif

import clibui

public enum Orientation {
	case Vertical
	case Horizontal
}

public struct InitOptions {
	var options:clibui.uiInitOptions

	public init() {
		options = clibui.uiInitOptions()
	}
}

public func initialize(options:inout InitOptions) -> String? {
	if let output = clibui.uiInit(&options.options) {
		return String(cString: output)
	}
	return nil
}

public func main() -> Void {
	clibui.uiMain()
}

public func uninit() -> Void {
	clibui.uiUninit()
}

public func quit() -> Void {
	clibui.uiQuit()
}

public func openFile(parent:Window) -> String? {
	if let cPath = clibui.uiOpenFile(parent.op) {
		let filename = String(cString: cPath)
		clibui.uiFreeText(cPath)
		return filename
	}
	return nil
}

public func saveFile(parent:Window) -> String? {
	if let cPath = clibui.uiSaveFile(parent.op) {
		let filename = String(cString: cPath)
		clibui.uiFreeText(cPath)
		return filename
	}
	return nil
}

// TODO: The `uiOnShouldQuit` implementation here is an absolute mess,
//   there really should be a better way to deal with this
class onShouldQuitHandlerStruct {
	var onShouldQuitHandler: () -> Bool = { return true }
}
var osqh_obj = onShouldQuitHandlerStruct()
public func on(shouldQuit: @escaping () -> Bool) -> Void {
	osqh_obj.onShouldQuitHandler = shouldQuit
	clibui.uiOnShouldQuit({ (d) -> Int32 in
		if let objectPointer = d {
			let object = Unmanaged<onShouldQuitHandlerStruct>.fromOpaque(objectPointer).takeUnretainedValue()

			return object.onShouldQuitHandler() ? 1 : 0
		}
		return 1
	}, UnsafeMutablePointer<Void>(Unmanaged.passUnretained(osqh_obj).toOpaque()))
}

public func messageBox(parent:Window, title:String, description:String) -> Void {
	clibui.uiMsgBox(parent.op, title, description)
}

public func messageBoxError(parent:Window, title:String, description:String) -> Void {
	clibui.uiMsgBoxError(parent.op, title, description)
}
