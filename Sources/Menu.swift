import clibui

public class Menu {
	let op:OpaquePointer;

	public init(title:String) {
		self.op = clibui.uiNewMenu(title)
	}

	public func append(item:String) -> MenuItem {
		return MenuItem(clibui.uiMenuAppendItem(self.op, item))
	}

	public func append(checkItem:String) -> MenuItem {
		return MenuItem(clibui.uiMenuAppendCheckItem(self.op, checkItem))
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
