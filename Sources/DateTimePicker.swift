import clibui

public enum Picker {
	case Date
	case Time
	case DateTime
}

public class DateTimePicker: Control {
	let op:OpaquePointer;

	public init(type:Picker=Picker.DateTime) {

		switch type {
			case .Date:
				self.op = clibui.uiNewDatePicker()
			case .Time:
				self.op = clibui.uiNewTimePicker()
			case .DateTime:
				self.op = clibui.uiNewDateTimePicker()
		}

		super.init(UnsafeMutablePointer(self.op))
	}

}
