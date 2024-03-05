//
//  Sail.swift
//
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation

enum SailType {
	case mainsail
	case stayedHeadsail
	case unstayedHeadsail
	case symSpinnaker
	case asySpinnaker
}

protocol Sail {
	typealias Length = Measurement<UnitLength>
	typealias Area = Measurement<UnitArea>

	var area: Measurement<UnitArea> { get }
}

extension Sail {
	/// Returns a point that is equidistant from `pt1` and `pt2` that is also at an x of `girth`
	///
	/// - Parameters
	///		- pt1,  pt2: `CGPoint`s of the two ends of the segment to bisect
	///		- girth: measured sail width at the point being sought
	///
	/// Facilitates producing a more accurate outline of a sail.
	///
	/// ```
	/// let midWidthPoint = midLeechPoint(headPoint, clewPoint, girth: halfWidth)
	/// ```
	/// The *ERS* defines the method by which mid-girth measurements are taken, and this
	/// function returns a point that is consistent with that procedure.
	///
	/// Systems like *ORC* specify different height for girth measurements to produce rated
	/// sail areas, and this function produces a smaller depiction because these points will
	/// be below the ones produced by *ORC*
	static func midLeechPoint(_ pt1: CGPoint, _ pt2: CGPoint, girth: CGFloat) -> CGPoint {
		let (left,right) = pt1.x < pt2.x ? (pt1, pt2) : (pt2, pt1)
		let run = (right.x - left.x)
		let rslope = run == 0 ? 0 : 1 / ((left.y - right.y) / run)
		let (midx,midy) = (left.x + (right.x - left.x)/2, left.y - ( left.y - right.y )/2)
		let yOffset = midy - midx * rslope
		return CGPoint(x: girth, y: girth * rslope + yOffset)
	}
		/// Common formatter for measurements.
		///
		/// Supports localisation.
	var measFormatter: MeasurementFormatter {
		let measFormatter = MeasurementFormatter()
		measFormatter.unitStyle = .medium
		return measFormatter
	}

}
extension CGFloat {
	/// Returns a string representing the number rounded, with 0.0005 rounding to 0.001
	var round3: String {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 3
		formatter.roundingMode = .halfUp
		return formatter.string(from: self as NSNumber)!
	}
}
