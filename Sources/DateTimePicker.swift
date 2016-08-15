import clibui

enum Picker {
	case Date
	case Time
	case DateTime
}

class DateTimePicker: Control {
	let op:OpaquePointer;

	init(type:Picker=Picker.DateTime) {

		switch type {
			case .Date:
				self.op = clibui.uiNewDatePicker()
			case .Time:
				self.op = clibui.uiNewTimePicker()
			case .DateTime:
				self.op = clibui.uiNewDateTimePicker()
		}

		super.init(c: UnsafeMutablePointer(self.op))
	}

}
