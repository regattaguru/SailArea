	//
	//  Mainsail.swift
	//
	//
	//  Created by Paul Miller on 2024-02-29.
	//

import Foundation
//import CoreGraphics

struct Mainsail: Sail {

	enum GirthPoint {
		case head,upper,threeQuarter,half,quarter
	}
		// MARK: - Measurements
		/// Luff length alias 'p'
	var luff: Length
		/// Foot length alias 'e'
	var foot: Length
		/// Leech length - optional but should be required
	var leech: Length?
		// Girths
	var headWidth: Length?
	var upperWidth: Length?
	var threeQuarterWidth: Length?
	var halfWidth: Length?
	var quarterWidth: Length?
	var footMedian: Length?
	var luffPerp: Length?

	var mainType: MainType = .normal

	var area: Area {
		let area: Double = trapezoidRuleArea()
		return Area(value: area, unit: .squareMeters)
	}

	var leechPoints: [CGPoint] {
		let clew = CGPoint(x: foot.value, y: 0)
		let head = CGPoint(x: getVal(.head), y: luff.value)
		let mid = Self.midLeechPoint(head, clew, girth: getVal(.half))
		let qtr = Self.midLeechPoint(mid, clew, girth: getVal(.quarter))
		let thq = Self.midLeechPoint(head, mid, girth: getVal(.threeQuarter))
		let upp = Self.midLeechPoint(head,thq, girth: getVal(.upper))
		return [head,upp,thq,mid,qtr,clew]
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

	func trapezoidRuleArea() -> Double {
			/// P / 8 (E+2·QW+2·HW+1.5·TW+UW+0.5·HB)
		let p = luff.value
		let e = foot.value
		let hb = getVal(.head)
		let uw = getVal(.upper)
		let tw = getVal(.threeQuarter)
		let hw = getVal(.half)
		let qw = getVal(.quarter)
		let area = p / 8 * (e + 2 * qw + 2 * hw + 1.5 * tw + uw + 0.5 * hb )
		return area
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

}

