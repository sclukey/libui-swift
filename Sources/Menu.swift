import clibui

class Menu {
	let op:OpaquePointer;

	init(title:String) {
		self.op = clibui.uiNewMenu(title)
	}
	/*
	_UI_EXTERN uiMenuItem *uiMenuAppendItem(uiMenu *m, const char *name);
	_UI_EXTERN uiMenuItem *uiMenuAppendCheckItem(uiMenu *m, const char *name);
	_UI_EXTERN uiMenuItem *uiMenuAppendQuitItem(uiMenu *m);
	_UI_EXTERN uiMenuItem *uiMenuAppendPreferencesItem(uiMenu *m);
	_UI_EXTERN uiMenuItem *uiMenuAppendAboutItem(uiMenu *m);
	_UI_EXTERN void uiMenuAppendSeparator(uiMenu *m);
	*/

	func append(item:String) -> MenuItem {
		return MenuItem(clibui.uiMenuAppendItem(self.op, item))
	}

	func append(checkItem:String) -> MenuItem {
		return MenuItem(clibui.uiMenuAppendCheckItem(self.op, checkItem))
	}

	func appendQuit() -> MenuItem {
		return MenuItem(clibui.uiMenuAppendQuitItem(self.op))
	}

	func appendPreferences() -> MenuItem {
		return MenuItem(clibui.uiMenuAppendPreferencesItem(self.op))
	}

	func appendAbout() -> MenuItem {
		return MenuItem(clibui.uiMenuAppendAboutItem(self.op))
	}

	func appendSeparator() -> Void {
		clibui.uiMenuAppendSeparator(self.op)
	}

}
