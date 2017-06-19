import clibui

// This global is used to implement the `AreaHandler` functions. Since the
// handler functions here don't have a `data` argument, I have to maintain this
// global so that the C functions can access the Swift objects.
var uiAreaMap = [Int: Area]()

public class Area: Control {
	let op:OpaquePointer;
	public let handler:AreaHandler;

	init(_ op:OpaquePointer, handler:AreaHandler) {
		self.op = op
		self.handler = handler

		super.init(UnsafeMutablePointer(self.op))

		uiAreaMap[op.hashValue] = self
	}

	deinit {
		uiAreaMap.removeValue(forKey:op.hashValue)
	}

	public convenience init(handler:AreaHandler) {
		self.init(clibui.uiNewArea(&handler.handler), handler:handler);
	}

	public func queueRedrawAll() -> Void {
		clibui.uiAreaQueueRedrawAll(self.op);
	}
}

public class ScrollingArea: Area {
	public init(handler:AreaHandler, width:Int32, height:Int32) {
		super.init(clibui.uiNewScrollingArea(&handler.handler, width, height), handler:handler)
	}

	public func setSize(width:Int32, height:Int32) -> Void {
		clibui.uiAreaSetSize(self.op, width, height)
	}

	public func scrollTo(x:Double, y:Double, width:Double, height:Double) -> Void {
		clibui.uiAreaScrollTo(self.op, x, y, width, height)
	}
}

public class AreaHandler {
	var handler:clibui.uiAreaHandler;

	private var onDrawHandler: (Area, DrawParams) -> Void
	private var onMouseEventHandler: (Area, MouseEvent) -> Void
	private var onMouseCrossedHandler: (Area, Int) -> Void
	private var onDragBrokenHandler: (Area) -> Void
	private var onKeyEventHandler: (Area, KeyEvent) -> Int

	public init() {
		self.onDrawHandler = { _ in }
		self.onMouseEventHandler = { _ in }
		self.onMouseCrossedHandler = { _ in }
		self.onDragBrokenHandler = { _ in }
		self.onKeyEventHandler = { _ in return 0 }

		handler = clibui.uiAreaHandler()

		// Give these defaults, otherwise libui will segfault
		handler.Draw = { _ in }
		handler.MouseEvent = { _ in }
		handler.MouseCrossed = { _ in }
		handler.DragBroken = { _ in }
		handler.KeyEvent = { _ in return 0 }
	}

	public func on(draw: @escaping (Area, DrawParams) -> Void) -> Void {
		onDrawHandler = draw
		handler.Draw = { (ah, a, params) -> Void in
			if let aPointer:OpaquePointer = a {
				if let sArea:Area = uiAreaMap[aPointer.hashValue] {
					if let drawParams = params {
						sArea.handler.onDrawHandler(sArea, DrawParams(withCStruct:drawParams.pointee))
					}
				}
			}
		}
	}

	public func on(mouseEvent: @escaping (Area, MouseEvent) -> Void) -> Void {
		onMouseEventHandler = mouseEvent
		handler.MouseEvent = { (ah, a, event) -> Void in
			if let aPointer:OpaquePointer = a {
				if let sArea:Area = uiAreaMap[aPointer.hashValue] {
					if let mE = event {
						sArea.handler.onMouseEventHandler(sArea, MouseEvent(withCStruct:mE.pointee))
					}
				}
			}
		}
	}

	public func on(mouseCrossed: @escaping (Area, Int) -> Void) -> Void {
		onMouseCrossedHandler = mouseCrossed
		handler.MouseCrossed = { (ah, a, intval) -> Void in
			if let aPointer:OpaquePointer = a {
				if let sArea:Area = uiAreaMap[aPointer.hashValue] {
					sArea.handler.onMouseCrossedHandler(sArea, Int(intval))
				}
			}
		}
	}

	public func on(dragBroken: @escaping (Area) -> Void) -> Void {
		onDragBrokenHandler = dragBroken
		handler.DragBroken = { (ah, a) -> Void in
			if let aPointer:OpaquePointer = a {
				if let sArea:Area = uiAreaMap[aPointer.hashValue] {
					sArea.handler.onDragBrokenHandler(sArea)
				}
			}
		}
	}

	public func on(keyEvent: @escaping (Area, KeyEvent) -> Int) -> Void {
		onKeyEventHandler = keyEvent
		handler.KeyEvent = { (ah, a, event) -> Int32 in
			if let aPointer:OpaquePointer = a {
				if let sArea:Area = uiAreaMap[aPointer.hashValue] {
					if let kE = event {
						return Int32(sArea.handler.onKeyEventHandler(sArea, KeyEvent(withCStruct:kE.pointee)))
					}
				}
			}
			return 0
		}
	}
}

// This is another bunch of rewritten enumerations and supporting structs,
// see `DrawText.swift` for more discussion, but the bottom line is that this
// is unfortunate but I think it provides a nicer Swift API.

public enum ModifierKeys: Int {
	case Ctrl  = 0b000
	case Alt   = 0b001
	case Shift = 0b010
	case Super = 0b100
}

public struct MouseEvent {
	public var x:Double;
	public var y:Double;

	public var areaWidth:Double;
	public var areaHeight:Double;

	public var down:Int32;
	public var up:Int32;

	public var count:Int32;

	public var modifiers:ModifierKeys;

	public var held1To64:UInt64;

	init(withCStruct cStruct:clibui.uiAreaMouseEvent) {
		self.x = cStruct.X
		self.y = cStruct.Y
		self.areaWidth = cStruct.AreaWidth
		self.areaHeight = cStruct.AreaHeight
		self.down = cStruct.Down
		self.up = cStruct.Up
		self.count = cStruct.Count
		self.held1To64 = cStruct.Held1To64

		// I'm ok with this ! because I have explicitely ensured that the C
		// enum values match the Swift enum values
		self.modifiers = ModifierKeys(rawValue: Int(cStruct.Modifiers))!
	}
}

public enum ExtKey: Int {
	case Escape = 1
	case Insert
	case Delete
	case Home
	case End
	case PageUp
	case PageDown
	case Up
	case Down
	case Left
	case Right
	case F1
	case F2
	case F3
	case F4
	case F5
	case F6
	case F7
	case F8
	case F9
	case F10
	case F11
	case F12
	case N0
	case N1
	case N2
	case N3
	case N4
	case N5
	case N6
	case N7
	case N8
	case N9
	case NDot
	case NEnter
	case NAdd
	case NSubtract
	case NMultiply
	case NDivide
}

public struct KeyEvent {
	public var key:String;
	public var extKey:ExtKey;
	public var modifier:ModifierKeys;
	public var modifiers:ModifierKeys;
	public var up:Int;

	init(withCStruct cStruct:clibui.uiAreaKeyEvent) {
		self.up = Int(cStruct.Up)
		self.key = String(cStruct.Key)

		// I'm ok with these !'s because I have explicitely ensured that the C
		// enum values match the Swift enum values
		self.modifier = ModifierKeys(rawValue: Int(cStruct.Modifier))!
		self.modifiers = ModifierKeys(rawValue: Int(cStruct.Modifiers))!
		self.extKey = ExtKey(rawValue: Int(cStruct.ExtKey))!
	}
}
