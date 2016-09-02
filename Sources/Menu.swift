import clibui

public class Menu {
	let op:OpaquePointer;

	public init(title:String) {
		self.op = clibui.uiNewMenu(title)
	}

	public func appendItem(_ title:String, checkable:Bool = false) -> MenuItem {
		if checkable {
			return MenuItem(clibui.uiMenuAppendCheckItem(self.op, title))
		} else {
			return MenuItem(clibui.uiMenuAppendItem(self.op, title))
		}
	}

	public func appendQuit() -> MenuItem {
		return MenuItem(clibui.uiMenuAppendQuitItem(self.op))
	}

	public func appendPreferences() -> MenuItem {
		return MenuItem(clibui.uiMenuAppendPreferencesItem(self.op))
	}

	public func appendAbout() -> MenuItem {
		return MenuItem(clibui.uiMenuAppendAboutItem(self.op))
	}

	public func appendSeparator() -> Void {
		clibui.uiMenuAppendSeparator(self.op)
	}

}
