#if os(OSX)
import AppKit
#endif

import clibui

/// Helper for adding names to orientations
public enum Orientation {
	case Vertical
	case Horizontal
}

/// Initialization options
public struct InitOptions {
	var options:clibui.uiInitOptions

	/**
	    Creates an instance with default initialization options
	*/
	public init() {
		options = clibui.uiInitOptions()
	}
}

/**
    Initializes LibUI

    - Parameter options: Initialization options.

    - Returns: An error string on error, otherwise `nil`.
*/
public func initialize(options:inout InitOptions) -> String? {
	if let output = clibui.uiInit(&options.options) {
		return String(cString: output)
	}
	return nil
}

/**
    Start the main event loop

    This call does not return until LibUI quits
*/
public func main() -> Void {
	clibui.uiMain()
}

/**
    Destroy all object and free all memory used by LibUI
*/
public func uninit() -> Void {
	clibui.uiUninit()
}

/**
    Quit LibUI (i.e., stop the main event loop (i.e. return from `ui.main()`))
*/
public func quit() -> Void {
	clibui.uiQuit()
}

/**
    Open a dialog for selecting a file to open

    - Parameter parent: Parent window for the dialog box

    - Returns: The path of the selected file on success, or `nil` if the dialog
      is canceled.
*/
public func openFile(parent:Window) -> String? {
	if let cPath = clibui.uiOpenFile(parent.op) {
		let filename = String(cString: cPath)
		clibui.uiFreeText(cPath)
		return filename
	}
	return nil
}

/**
    Open a dialog for selecting a file to save

    This one shows the overwrite warning and such.

    - Parameter parent: Parent window for the dialog box

    - Returns: The path of the file on success, or `nil` if the dialog is
      canceled.
*/
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

/**
    Defines what to do if the UI asks to quit

    - Parameter shouldQuit: A function or closure that will be called when the
      program asks to quit. This function return `true` if the program should
      quit, or `false` if not.
*/
public func on(shouldQuit: @escaping () -> Bool) -> Void {
	osqh_obj.onShouldQuitHandler = shouldQuit
	clibui.uiOnShouldQuit({ (d) -> Int32 in
		if let objectPointer = d {
			let object = Unmanaged<onShouldQuitHandlerStruct>.fromOpaque(objectPointer).takeUnretainedValue()

			return object.onShouldQuitHandler() ? 1 : 0
		}
		return 1
	}, UnsafeMutableRawPointer(Unmanaged.passUnretained(osqh_obj).toOpaque()))
}

/**
    Show a message box

    - Parameter parent:      The parent window for the message box
    - Parameter title:       The string to display in the title bar of the
      message box
    - Parameter description: The main message of the box
*/
public func messageBox(parent:Window, title:String, description:String) -> Void {
	clibui.uiMsgBox(parent.op, title, description)
}

/**
    Show a message box for an error

    - Parameter parent:      The parent window for the message box
    - Parameter title:       The string to display in the title bar of the
      message box
    - Parameter description: The main message of the box
*/
public func messageBoxError(parent:Window, title:String, description:String) -> Void {
	clibui.uiMsgBoxError(parent.op, title, description)
}
