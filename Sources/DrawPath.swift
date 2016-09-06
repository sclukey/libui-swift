import clibui

public class DrawPath {
	let op:OpaquePointer

	public init(fillMode:FillMode) {
		self.op = clibui.uiDrawNewPath(UInt32(fillMode.rawValue))
	}

	deinit {
		clibui.uiDrawFreePath(self.op)
	}

	public func newFigure(at point:(x:Double, y:Double)) -> Void {
		clibui.uiDrawPathNewFigure(self.op, point.x, point.y)
	}

	public func newFigureWithArc(center:(x:Double, y:Double), radius:Double, startAngle:Double, sweep:Double, negative:Bool) -> Void {
		clibui.uiDrawPathNewFigureWithArc(self.op, center.x, center.y, radius, startAngle, sweep, negative ? 1 : 0)
	}

	public func lineTo(point:(x:Double, y:Double)) -> Void {
		clibui.uiDrawPathLineTo(self.op, point.x, point.y)
	}

	public func closeFigure() -> Void {
		clibui.uiDrawPathCloseFigure(self.op)
	}

	public func end() -> Void {
		clibui.uiDrawPathEnd(self.op)
	}

	public func arcTo(center:(x:Double, y:Double), radius:Double, startAngle:Double, sweep:Double, negative:Bool) -> Void {
		clibui.uiDrawPathArcTo(self.op, center.x, center.y, radius, startAngle, sweep, negative ? 1 : 0)
	}

	public func bezierTo(c1:(x:Double, y:Double), c2:(x:Double, y:Double), end:(x:Double, y:Double)) -> Void {
		clibui.uiDrawPathBezierTo(self.op, c1.x, c1.y, c2.x, c2.y, end.x, end.y)
	}

	public func addRectangle(at point:(x:Double, y:Double), withSize size:(width:Double, height:Double)) -> Void {
		clibui.uiDrawPathAddRectangle(self.op, point.x, point.y, size.width, size.height)
	}

	public func stroke(withBrush brush:DrawBrush, andStroke stroke:StrokeParams, inContext context:DrawContext) -> Void {
		var cBrush = brush.toC()
		var cStroke = stroke.toC()
		clibui.uiDrawStroke(context.op, self.op, &cBrush, &cStroke)
	}

	public func fill(withBrush brush:DrawBrush, inContext context:DrawContext) -> Void {
		var cBrush = brush.toC()
		clibui.uiDrawFill(context.op, self.op, &cBrush)
	}
}

public class DrawContext {
	let op:OpaquePointer;

	init(_ cStruct:OpaquePointer) {
		self.op = cStruct
	}

	public func transform(matrix:DrawMatrix) -> Void {
		clibui.uiDrawTransform(self.op, &matrix.cStruct);
	}
}

public struct DrawParams {
	public var context:DrawContext

	public var areaWidth:Double
	public var areaHeight:Double

	public var clipX:Double
	public var clipY:Double
	public var clipWidth:Double
	public var clipHeight:Double

	init(withCStruct cStruct:clibui.uiAreaDrawParams) {
		self.areaWidth = cStruct.AreaWidth
		self.areaHeight = cStruct.AreaHeight
		self.clipX = cStruct.ClipX
		self.clipY = cStruct.ClipY
		self.clipWidth = cStruct.ClipWidth
		self.clipHeight = cStruct.ClipHeight

		self.context = DrawContext(cStruct.Context)
	}
}
