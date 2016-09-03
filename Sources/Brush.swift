import clibui

public enum BrushType: Int {
	case Solid
	case LinearGradient
	case RadialGradient
	case Image
}

public enum LineCap: Int {
	case Flat
	case Round
	case Square
}

public enum LineJoin: Int {
	case Miter
	case Round
	case Bevel
}

public let DefaultMiterLimit = 10.0

public enum FillMode: Int {
	case Winding
	case Alternate
}

public class DrawMatrix {
	var cStruct:clibui.uiDrawMatrix

	public var m11:Double;
	public var m12:Double;
	public var m21:Double;
	public var m22:Double;
	public var m31:Double;
	public var m32:Double;

	init(fromC cStruct:clibui.uiDrawMatrix) {
		self.cStruct = cStruct
		self.m11 = self.cStruct.M11
		self.m12 = self.cStruct.M12
		self.m21 = self.cStruct.M21
		self.m22 = self.cStruct.M22
		self.m31 = self.cStruct.M31
		self.m32 = self.cStruct.M32
	}

	func update() -> Void {
		self.m11 = self.cStruct.M11
		self.m12 = self.cStruct.M12
		self.m21 = self.cStruct.M21
		self.m22 = self.cStruct.M22
		self.m31 = self.cStruct.M31
		self.m32 = self.cStruct.M32
	}

	public convenience init() {
		let cStruct = clibui.uiDrawMatrix()
		self.init(fromC:cStruct)
	}

	public func setIdentity() -> Void {
		clibui.uiDrawMatrixSetIdentity(&self.cStruct)
		self.update()
	}

	public func translate(origin:(x:Double, y:Double)) -> Void {
		clibui.uiDrawMatrixTranslate(&self.cStruct, origin.x, origin.y)
		self.update()
	}
}

public class DrawBrush {
	public var type:BrushType;

	// solid brushes
	public var r:Double;
	public var g:Double;
	public var b:Double;
	public var a:Double;

	// gradient brushes
	public var x0:Double;		// linear: start X, radial: start X
	public var y0:Double;		// linear: start Y, radial: start Y
	public var x1:Double;		// linear: end X, radial: outer circle center X
	public var y1:Double;		// linear: end Y, radial: outer circle center Y
	public var outerRadius:Double;		// radial gradients only
	public var stops:[BrushGradientStop];
	private var cStops:UnsafeMutablePointer<clibui.uiDrawBrushGradientStop>
	private var cNumStops:Int

	init(fromC cStruct:clibui.uiDrawBrush) {
		self.type = BrushType(rawValue: Int(cStruct.Type))!

		self.r = cStruct.R
		self.g = cStruct.G
		self.b = cStruct.B
		self.a = cStruct.A
		self.x0 = cStruct.X0
		self.y0 = cStruct.Y0
		self.x1 = cStruct.X1
		self.y1 = cStruct.Y1
		self.outerRadius = cStruct.OuterRadius


		self.stops = []
		if let cStops = cStruct.Stops {
			for i in 0..<cStruct.NumStops {
				let stop = BrushGradientStop(fromC: cStops[i])
				self.stops.append(stop)
			}
		}

		// Initialize the self.cStops
		self.cStops = UnsafeMutablePointer<clibui.uiDrawBrushGradientStop>.allocate(capacity:cStruct.NumStops)
		if cStruct.NumStops > 0 {
			self.cStops.initialize(from:cStruct.Stops, count:cStruct.NumStops)
		}
		self.cNumStops = cStruct.NumStops
	}

	public convenience init() {
		let cStruct = clibui.uiDrawBrush()
		self.init(fromC:cStruct)
	}

	deinit {
		self.cStops.deinitialize()
		self.cStops.deallocate(capacity:self.cNumStops)
	}

	private func updateCStops() -> Void {
		// Remove the previous cStops
		self.cStops.deinitialize()
		self.cStops.deallocate(capacity:self.cNumStops)

		// Create the new cStops
		self.cStops = UnsafeMutablePointer<clibui.uiDrawBrushGradientStop>.allocate(capacity:self.stops.count)
		if self.stops.count > 0 {
			var arrayOfCStructs:[clibui.uiDrawBrushGradientStop] = []
			for thisStop in self.stops {
				arrayOfCStructs.append(thisStop.toC())
			}
			cStops.initialize(from:arrayOfCStructs, count:self.stops.count)
		}
		self.cNumStops = self.stops.count
	}

	public func toC() -> clibui.uiDrawBrush {
		var cStruct = clibui.uiDrawBrush()
		cStruct.Type = UInt32(self.type.rawValue)
		cStruct.R = self.r
		cStruct.G = self.g
		cStruct.B = self.b
		cStruct.A = self.a
		cStruct.X0 = self.x0
		cStruct.Y0 = self.y0
		cStruct.X1 = self.x1
		cStruct.Y1 = self.y1
		cStruct.OuterRadius = self.outerRadius

		updateCStops()
		cStruct.Stops = self.cStops
		cStruct.NumStops = self.cNumStops

		return cStruct
	}
}

public struct BrushGradientStop {
	public var pos:Double;
	public var r:Double;
	public var g:Double;
	public var b:Double;
	public var a:Double;

	init(fromC cStruct:clibui.uiDrawBrushGradientStop) {
		self.pos = cStruct.Pos
		self.r = cStruct.R
		self.g = cStruct.G
		self.b = cStruct.B
		self.a = cStruct.A
	}

	func toC() -> clibui.uiDrawBrushGradientStop {
		var cStruct = clibui.uiDrawBrushGradientStop()
		cStruct.Pos = self.pos
		cStruct.R = self.r
		cStruct.G = self.g
		cStruct.B = self.b
		cStruct.A = self.a

		return cStruct
	}
};

public class StrokeParams {
	public var cap:LineCap;
	public var join:LineJoin;

	public var thickness:Double;
	public var miterLimit:Double;
	public var dashes:[Double];

	public var dashPhase:Double;

	private var cDashes:UnsafeMutablePointer<Double>
	private var cNumDashes:Int

	init(fromC cStruct:clibui.uiDrawStrokeParams) {
		self.cap = LineCap(rawValue: Int(cStruct.Cap))!
		self.join = LineJoin(rawValue: Int(cStruct.Join))!

		self.thickness = cStruct.Thickness
		self.miterLimit = cStruct.MiterLimit

		self.dashes = []
		if let cDashes = cStruct.Dashes {
			for i in 0..<cStruct.NumDashes {
				self.dashes.append(cDashes[i])
			}
		}

		self.dashPhase = cStruct.DashPhase

		// Initialize the self.cDashes
		self.cDashes = UnsafeMutablePointer<Double>.allocate(capacity:cStruct.NumDashes)
		if cStruct.NumDashes > 0 {
			self.cDashes.initialize(from:cStruct.Dashes, count:cStruct.NumDashes)
		}
		self.cNumDashes = cStruct.NumDashes
	}

	public convenience init() {
		let cStruct = clibui.uiDrawStrokeParams()
		self.init(fromC:cStruct)
	}

	deinit {
		self.cDashes.deinitialize()
		self.cDashes.deallocate(capacity:self.cNumDashes)
	}

	private func updateCDashes() -> Void {
		// Remove the previous cDashes
		self.cDashes.deinitialize()
		self.cDashes.deallocate(capacity:self.cNumDashes)

		// Create the new cDashes
		self.cDashes = UnsafeMutablePointer<Double>.allocate(capacity:self.dashes.count)
		if self.dashes.count > 0 {
			cDashes.initialize(from:self.dashes)
		}
		self.cNumDashes = self.dashes.count
	}

	func toC() -> clibui.uiDrawStrokeParams {
		var cStruct = clibui.uiDrawStrokeParams()

		cStruct.Cap = UInt32(self.cap.rawValue)
		cStruct.Join = UInt32(self.join.rawValue)
		cStruct.Thickness = self.thickness
		cStruct.MiterLimit = self.miterLimit
		cStruct.DashPhase = self.dashPhase

		updateCDashes()
		cStruct.Dashes = self.cDashes
		cStruct.NumDashes = self.cNumDashes

		return cStruct
	}
}

