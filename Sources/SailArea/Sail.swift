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
	var area: Measurement<UnitArea> { get }
}

extension Sail {
	static func midLeechPoint(_ pt1: CGPoint, _ pt2: CGPoint, girth: CGFloat) -> CGPoint {
		let (left,right) = pt1.x < pt2.x ? (pt1, pt2) : (pt2, pt1)
		let run = (right.x - left.x)
		let rslope = run == 0 ? 0 : 1 / ((left.y - right.y) / run)
		let (midx,midy) = (left.x + (right.x - left.x)/2, left.y - ( left.y - right.y )/2)
		let yOffset = midy - midx * rslope
		return CGPoint(x: girth, y: girth * rslope + yOffset)
	}
}
extension CGFloat {
	var round3: String {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 3
		return formatter.string(from: self as NSNumber)!
	}
}

//func midLeechPoint(_ pt1: CGPoint, _ pt2: CGPoint, girth: CGFloat) -> CGPoint {
//	let (left,right) = pt1.x < pt2.x ? (pt1, pt2) : (pt2, pt1)
//	let run = (right.x - left.x)
//	let rslope = run == 0 ? 0 : 1 / ((left.y - right.y) / run)
//	let (midx,midy) = (left.x + (right.x - left.x)/2, left.y - ( left.y - right.y )/2)
//	let yOffset = midy - midx * rslope
//	return CGPoint(x: girth, y: girth * rslope + yOffset)
//}
