//
//  File.swift
//  
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation

extension Mainsail {
	var mhwh: Double {
		(luff.value/2.0) + (getVal(.half) - foot.value / 2.0)/luff.value * foot.value
	}
	var mqwh: Double {
		(mhwh/2.0) + (getVal(.quarter) - (foot.value + mhwh)/2)/mhwh * foot.value/2
	}
	var mtwh: Double {
		((mhwh + luff.value)/2) + ((getVal(.threeQuarter) - getVal(.half) / 2)/(luff.value - mhwh)) * getVal(.half)
	}
	var muwh: Double {
		((mtwh + luff.value)/2) + ((getVal(.upper) - getVal(.threeQuarter) / 2) / (luff.value - mtwh)) * getVal(.threeQuarter)
	}
	func orcHeights() -> [String:Double] {
		let p = luff.value
		let e = foot.value
		let hw = getVal(.half)
		let qw = getVal(.quarter)
		let tw = getVal(.threeQuarter)
		let uw = getVal(.upper)

		let hwh = p/2 + (hw - e/2)/p * e
		let qwh = hwh/2 + (qw - (e+hw)/2)/hwh * (e-hw)
		let twh = (hwh + p)/2 + (tw - hw/2)/(p - hwh) * hw
		let uwh = (twh + p)/2 + (uw - tw/2)/(p - twh) * tw

		return [
			"hwh": hwh,
			"qwh": qwh,
			"twh": twh,
			"uwh": uwh
		]
	}

}
