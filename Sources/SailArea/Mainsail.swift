	//  Mainsail.swift
	//
	//
	//  Created by Paul Miller on 2024-02-29.
	//

import Foundation
import CoreGraphics

struct Mainsail: Sail {
	typealias Linear = Measurement<UnitLength>
	typealias Area = Measurement<UnitArea>

	enum GirthPoint {
		case head,upper,threeQuarter,half,quarter
	}

		// p
	var luff: Linear
		// e
	var foot: Linear
	var leech: Linear?
		// Girths
	var headWidth: Linear?
	var upperWidth: Linear?
	var threeQuarterWidth: Linear?
	var halfWidth: Linear?
	var quarterWidth: Linear?
	var footMedian: Linear?
	var luffPerp: Linear?

	var mainType: MainType = .normal

	var area: Area {
		let area: Double = trapezoidRuleArea()
		return Area(value: area, unit: .squareMeters)
	}

	func trapezoidRuleArea() -> Double {
			/// P / 8 (E+2·QW+2·HW+1.5·TW+UW+0.5·HB)
		let p = luff.value
		let e = foot.value
		let hb = getVal(.head)
		let uw = getVal(.upper)
		let tw = getVal(.threeQuarter)
		let hw = getVal(.half)
		let qw = getVal(.quarter)
		let area = p / 8 * (e + 2 * qw + 2 * hw + 1.5 * tw + uw + hb / 2 )
		return area
	}

	enum MainType {
		case normal,inMast,inBoom

		func fallback(for girth: GirthPoint) -> Double {
			switch girth {
			case .head:
				switch self {
				case .normal: 0.05
				case .inBoom: 0.05
				case .inMast: 0.045
				}
			case .upper:
				switch self {
				case .normal: 0.25
				case .inBoom: 0.22
				case .inMast: 0.18
				}
			case .threeQuarter:
				switch self {
				case .normal: 0.41
				case .inBoom: 0.35
				case .inMast: 0.25
				}
			case .half:
				switch self {
				case .normal: 0.66
				case .inBoom: 0.60
				case .inMast: 0.5
				}
			case .quarter:
				switch self {
				case .normal: 0.85
				case .inBoom: 0.82
				case .inMast: 0.77
				}
			}
		}
	}

	func getVal(_ point: GirthPoint) -> Double {
		switch point {
		case .head:
			return headWidth?.value ?? mainType.fallback(for: .head)
		case .upper:
			return upperWidth?.value ?? mainType.fallback(for: .upper)
		case .threeQuarter:
			return threeQuarterWidth?.value ?? mainType.fallback(for: .threeQuarter)
		case .half:
			return halfWidth?.value ?? mainType.fallback(for: .half)
		case .quarter:
			return quarterWidth?.value ?? mainType.fallback(for: .quarter)
		}
	}

	var leechPoints: [CGPoint] {
		let clew = CGPoint(x: foot.value, y: 0)
		let head = CGPoint(x: getVal(.head), y: luff.value)
		let mid = midGirthPoint(head, clew, girth: getVal(.half))
		let qtr = midGirthPoint(mid, clew, girth: getVal(.quarter))
		let thq = midGirthPoint(head, mid, girth: getVal(.threeQuarter))
		let upp = midGirthPoint(head,thq, girth: getVal(.upper))
		return [head,upp,thq,mid,qtr,clew]
	}

	func leechProfile() -> CGMutablePath? {
		let pts = leechPoints
		var cp1: [CGPoint] = []
		var cp2: [CGPoint] = []
		BezierSpline.getCurveControlPoints(
			knots: pts,
			firstControlPoints: &cp1,
			secondControlPoints: &cp2
		)

		guard pts.count > 1 else { return nil }
		var ptArray = pts
		let firstPoint = ptArray.removeFirst()

		let path = CGMutablePath()
			// From clew point...
		path.move(to: pts.last!)
			// ...to tack point...
		path.addLine(to: CGPoint(x: 0, y: 0))
			// ...to head point...
		path.addLine(to: CGPoint(x: 0, y: pts.first!.y))
			// ...to aft head point
		path.addLine(to: firstPoint)
			// Current point is now aft head point - top of leech

		for i in 0..<ptArray.endIndex {
			path.addCurve(to: ptArray[i], control1: cp1[i], control2: cp2[i])
		}

		for i in 0..<pts.endIndex {
			path.move(to: pts[i])
		path.addLine(to: CGPoint(x: 0, y: pts[i].y))
			path.closeSubpath()
		}
		return path
	}

}

func midGirthPoint(_ pt1: CGPoint, _ pt2: CGPoint, girth: CGFloat) -> CGPoint {
	let (left,right) = pt1.x < pt2.x ? (pt1, pt2) : (pt2, pt1)
	let run = (right.x - left.x)
	let rslope = run == 0 ? 0 : 1 / ((left.y - right.y) / run)
	let (midx,midy) = (left.x + (right.x - left.x)/2, left.y - ( left.y - right.y )/2)
	let yOffset = midy - midx * rslope
	return CGPoint(x: girth, y: girth * rslope + yOffset)
}
