import AppKit

import clibui

/*
_UI_EXTERN void uiMsgBox(uiWindow *parent, const char *title, const char *description);
_UI_EXTERN void uiMsgBoxError(uiWindow *parent, const char *title, const char *description);
*/

func openFile(parent:Window) -> String? {
	if let cPath = clibui.uiOpenFile(parent.op) {
		return String(cString: cPath)
	}
	return nil
}

func saveFile(parent:Window) -> String? {
	if let cPath = clibui.uiSaveFile(parent.op) {
		return String(cString: cPath)
	}
	return nil
}

func messageBox(parent:Window, title:String, description:String) -> Void {
	clibui.uiMsgBox(parent.op, title, description)
}

func messageBoxError(parent:Window, title:String, description:String) -> Void {
	clibui.uiMsgBoxError(parent.op, title, description)
}

enum Align {
	case Fill
	case Start
	case Center
	case End
}

enum At {
	case Leading
	case Top
	case Trailing
	case Bottom
}

func convert(align:Align) -> clibui.uiAlign {
	switch align {
		case Align.Fill:   return UInt32(clibui.uiAlignFill)
		case Align.Start:  return UInt32(clibui.uiAlignStart)
		case Align.Center: return UInt32(clibui.uiAlignCenter)
		case Align.End:    return UInt32(clibui.uiAlignEnd)
	}
}

func convert(at:At) -> clibui.uiAt {
	switch at {
		case At.Leading:  return UInt32(clibui.uiAtLeading)
		case At.Top:      return UInt32(clibui.uiAtTop)
		case At.Trailing: return UInt32(clibui.uiAtTrailing)
		case At.Bottom:   return UInt32(clibui.uiAtBottom)
	}
}


struct ui {

	func smallStart() {
		let app = App()

		let w = Window(title:"New window", width:640, height:320, withMenu:true)
		w.on(closing: {
			print("New close handler")
			app.quit()
			return 0
		})

		w.on(contentSizeChanged: {
			print("The size of the contents has changed!")
		})

		w.on(positionChanged: {
			print("The position has changed!")
			let (x, y) = w.position
			print("X = \(x), Y = \(y)")
		})

		w.show()

		print(w.title)

		w.title = "This is the second title"
		// w.center()
		w.position = (100, 100)
		w.margined = true

		let box = Box(vertical:true)
		box.padded = true


		// let b = Button(text:"Button Text")

		// b.on(clicked: {
		// 	print("The button was clicked!")
		// })

		box.append(Label(text: "UI Test App"))

		let openButton = Button(text: "Open File")
		openButton.on(clicked: {
			if let path = openFile(parent:w) {
				print("Path: \(path)")
			} else {
				print("Cancelled")
			}
		})

		box.append(openButton)






		let msgButton = Button(text: "Send message")
		msgButton.on(clicked: {
			messageBox(parent:w, title:"Message title", description:"Message description")
		})

		box.append(msgButton)



		let colorButton = ColorButton()
		colorButton.on(changed: {
			let (r,g,b,a) = colorButton.color
			print("r = \(r), g = \(g), b = \(b), a = \(a)")
		})

		box.append(colorButton)





		let cb = Checkbox(text: "This is a checkbox")
		cb.on(toggled: {
			let c = cb.checked ? "Yes" : "No"
			print("Checked? \(c)")
		})

		cb.checked = true

		box.append(cb)

		let entry = Entry()
		entry.on(changed: {
			let currentText = entry.text
			print("Current text: \(currentText)")
		})
		box.append(entry)

		let slider = Slider(min:0, max:100)
		slider.on(changed: {
			print("Slider Currently: \(slider.value)")
		})
		box.append(slider)

		let spinb = Spinbox(min:0, max:100)
		spinb.on(changed: {
			print("Spinbox Currently: \(spinb.value)")
		})
		box.append(spinb)

		let pb = ProgressBar()
		pb.value = 50
		box.append(pb)

		box.append(Separator(vertical:true))

		let combo = Combobox()
		combo.append(text: "First")
		combo.append(text: "Second")
		combo.append(text: "Third")
		combo.on(selected: {
			print("Selected: \(combo.selected)")
		})
		box.append(combo)

		let ecombo = EditableCombobox()
		ecombo.append(text: "First")
		ecombo.append(text: "Second")
		ecombo.append(text: "Third")
		ecombo.on(changed: {
			print("Editable value: \(ecombo.text)")
		})
		box.append(ecombo)

		let radio = RadioButtons()
		radio.append(text: "First")
		radio.append(text: "Second")
		radio.append(text: "Third")
		radio.on(selected: {
			print("Ticked: \(radio.selected)")
		})
		box.append(radio)

		// This doesn't work for some reason
		// let mle = MultilineEntry()
		// mle.on(changed: {
		// 	let currentText = mle.text
		// 	print("Current text: \(currentText)")
		// })
		// box.append(mle)

		box.append(DateTimePicker(type:Picker.Time))

		w.set(child: box)
		app.main()

		// let c:Int = clibui.uiAllocControl(1, 1, 1, "Hey") as Int

		// clibui.uiWindowFullscreen(24)

		// var winStruct = clibui.uiWindow()

		// var mainWindow = 

		// var mainwin = clibui.uiControl(mainWindow)

		// let mainWindowControl = mainWindow as uiControl?
		// mainWindowControl.dynamicType.printClassName()

		// clibui.uiControlShow(&(mainWindow! as uiControl));
		// clibui.uiMain();

	}

    var text = "Hello, World!"
}
