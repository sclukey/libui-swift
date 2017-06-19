import clibui

public class Box: Control {
	let op:OpaquePointer;

	public init(_ orientation:Orientation) {
		switch orientation {
		case .Vertical:
			self.op = clibui.uiNewVerticalBox();
		case .Horizontal:
			self.op = clibui.uiNewHorizontalBox();
		}

		super.init(UnsafeMutablePointer(self.op))
	}

	public func append(_ child:Control, stretchy:Bool=false) -> Void {
		clibui.uiBoxAppend(self.op, child.control, stretchy ? 1 : 0)
	}

	public func delete(index:Int32) -> Void {
		clibui.uiBoxDelete(self.op, index)
	}

	public var padded:Bool {
		get {
			return clibui.uiBoxPadded(self.op) == 1
		}
		set {
			clibui.uiBoxSetPadded(self.op, newValue ? 1 : 0)
		}
	}

}
