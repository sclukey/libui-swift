import clibui

public func drawText(atPoint p:(x:Double, y:Double), inLayout l:DrawTextLayout, inContext c:DrawContext) -> Void {
	clibui.uiDrawText(c.op, p.x, p.y, l.op)
}

public class DrawTextFont {
	let op:OpaquePointer;

	// This should be used to convert the `uiDrawTextFont` pointers to this
	// class. This shouldn't be called, fonts are created by using the picker
	// or first setting a description and using `loadClosestFont`.
	init(_ pointer:OpaquePointer) {
		self.op = pointer
	}

	deinit {
		clibui.uiDrawFreeTextFont(self.op)
	}

	public func describe() -> DrawTextFontDescriptor {
		var cDesc = clibui.uiDrawTextFontDescriptor()
		clibui.uiDrawTextFontDescribe(self.op, &cDesc)
		return DrawTextFontDescriptor(cDesc)
	}

	public func getMetrics() -> DrawTextFontMetrics {
		var cMetrics = clibui.uiDrawTextFontMetrics()
		clibui.uiDrawTextFontGetMetrics(self.op, &cMetrics)
		return DrawTextFontMetrics(cMetrics)
	}

	public func fontHandle() -> UnsafeRawPointer {
		// This forced unwrapping should always be safe because this class
		// should only initialized when there is a valid font
		return UnsafeRawPointer(bitPattern:clibui.uiDrawTextFontHandle(self.op))!
	}
}

public class DrawTextLayout {
	let op:OpaquePointer;
	let text:String;

	public init(text:String, font:DrawTextFont, width:Double) {
		self.text = text
		let cString:UnsafePointer<Int8> = self.text.withCString {
			return $0
		}
		self.op = clibui.uiDrawNewTextLayout(cString, font.op, width)
	}

	deinit {
		clibui.uiDrawFreeTextLayout(self.op)
	}

	public func set(width:Double) -> Void {
		clibui.uiDrawTextLayoutSetWidth(self.op, width)
	}

	public func setColor(start:Int32, end:Int32, red:Double, green:Double, blue:Double, alpha:Double) -> Void {
		clibui.uiDrawTextLayoutSetColor(self.op, start, end, red, green, blue, alpha)
	}

	public func extents() -> (width:Double, height:Double) {
		var width:Double = 0;
		var height:Double = 0;
		clibui.uiDrawTextLayoutExtents(self.op, &width, &height)
		return (width, height)
	}
}

public func loadClosestFont(_ desc:DrawTextFontDescriptor) -> DrawTextFont? {
	var cDesc = desc.toC()
	if let r = clibui.uiDrawLoadClosestFont(&cDesc) {
		return DrawTextFont(r)
	}
	return nil
}

///////////////////////////////////////////////////////////////////////////////
// In the interest of nice naming for the enumeration types (removing the `ui`
// prefix, deduplicating the names, and having them in ui, rather than clibui)
// and because swift does not (cannot?) automatically import these nicely
// without modifying the original source code (to add `NS_ENUM` or something),
// I have chosen to manually rewrite the names. To convert between the clibui
// enums and the ones here, I am assuming that C enums start at 0 and increase
// sequentially (which I believe is an explicit standard) and that Swift does
// the same (which I don't believe is a "standard", but it is documented
// behavior).
///////////////////////////////////////////////////////////////////////////////

public enum DrawTextWeight: UInt32 {
	case Thin
	case UltraLight
	case Light
	case Book
	case Normal
	case Medium
	case SemiBold
	case Bold
	case UtraBold
	case Heavy
	case UltraHeavy
}

public enum DrawTextItalic: UInt32 {
	case Normal
	case Oblique
	case Italic
}

public enum DrawTextStretch: UInt32 {
	case UltraCondensed
	case ExtraCondensed
	case Condensed
	case SemiCondensed
	case Normal
	case SemiExpanded
	case Expanded
	case ExtraExpanded
	case UltraExpanded
}

public struct DrawTextFontDescriptor {
	var family: String;
	var size: Double;
	var weight: DrawTextWeight;
	var italic: DrawTextItalic;
	var stretch: DrawTextStretch;

	init(_ cDescription:clibui.uiDrawTextFontDescriptor) {
		self.family = String(cString:cDescription.Family)
		self.size = cDescription.Size
		self.weight = DrawTextWeight(rawValue:cDescription.Weight)!
		self.italic = DrawTextItalic(rawValue:cDescription.Italic)!
		self.stretch = DrawTextStretch(rawValue:cDescription.Stretch)!
	}

	func toC() -> clibui.uiDrawTextFontDescriptor {
		var cStruct: clibui.uiDrawTextFontDescriptor = clibui.uiDrawTextFontDescriptor()

		// TODO: Figure out the lifetime of this string object
		self.family.withCString({
			cStruct.Family = $0
		})
		cStruct.Size    = self.size
		cStruct.Weight  = UInt32(self.weight.rawValue)
		cStruct.Italic  = UInt32(self.italic.rawValue)
		cStruct.Stretch = UInt32(self.stretch.rawValue)

		return cStruct
	}
}

public struct DrawTextFontMetrics {
	var ascent: Double;
	var descent: Double;
	var leading: Double;
	var underlinePos: Double;
	var underlineThickness: Double;

	init(_ cMetrics:clibui.uiDrawTextFontMetrics) {
		self.ascent = cMetrics.Ascent
		self.descent = cMetrics.Descent
		self.leading = cMetrics.Leading
		self.underlinePos = cMetrics.UnderlinePos
		self.underlineThickness = cMetrics.UnderlineThickness
	}
}
