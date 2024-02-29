//
//  Headsail.swift
//
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation
import CoreGraphics

struct Headsail: Sail {
	typealias Linear = Measurement<UnitLength>
	typealias Area = Measurement<UnitArea>

	enum GirthPoint {
		case head,upper,threeQuarter,half,quarter
	}
		// MARK: - Measurements
		/// Luff length - from tack point to head point
	var luff: Linear
		/// Length from head point to clew point - optional, but should be required.
	var leech: Linear?
		/// Foot length - from clew point to tack point
	var foot: Linear
		/// Luff perpendicular
	var luffPerp: Linear
		/// Girths - all provided with fallback values
	var headWidth: Linear?
	var upperWidth: Linear?
	var threeQuarterWidth: Linear?
	var halfWidth: Linear?
	var quarterWidth: Linear?
	var footMedian: Linear?
		// MARK: -
	var area: Area {
		let area: Double = trapezoidRuleArea()
		return Area(value: area, unit: .squareMeters)
	}

	var leechPoints: [CGPoint] {
		[]
	}

	func trapezoidRuleArea() -> Double {
		/// Area = 0.1125 * HLU * (1.445HLP + 2HQW + 2HHW + 1.5HTW + HUW + 0.5HHB)
		let lu = luff.value
		let lp = luffPerp.value
		let hb = getVal(.head)
		let uw = getVal(.upper)
		let tw = getVal(.threeQuarter)
		let hw = getVal(.half)
		let qw = getVal(.quarter)
		return 0.1125 * lu * (1.445 * lp +
													2.000 * qw +
													2.000 * hw +
													1.500 * tw +
													1.000 * uw +
													0.500 * hb)
	}

	func getVal(_ girth: GirthPoint) -> Double {
		switch girth {
		case .head:
			return headWidth?.value ?? fallback(for: .head)
		case .upper:
			return upperWidth?.value ?? fallback(for: .upper)
		case .threeQuarter:
			return threeQuarterWidth?.value ?? fallback(for: .threeQuarter)
		case .half:
			return halfWidth?.value ?? fallback(for: .half)
		case .quarter:
			return quarterWidth?.value ?? fallback(for: .quarter)
		}
	}
		// MARK: Fallback values
	func fallback(for girth: GirthPoint) -> Double {
		switch girth {
		case .head:
			return luffPerp.value * 0.020
		case .upper:
			return luffPerp.value * 0.125 + getVal(.head) * 0.875
		case .threeQuarter:
			return luffPerp.value * 0.250 + getVal(.head) * 0.750
		case .half:
			return luffPerp.value * 0.500 + getVal(.head) * 0.500
		case .quarter:
			return luffPerp.value * 0.750 + getVal(.head) * 0.250
		}
	}
		// TODO: - implement leechPoints and leechProfile

}
