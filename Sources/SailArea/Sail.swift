//
//  Sail.swift
//
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation

enum SailType {
	case main
	case stayedHeadsail
	case unstayedHeadsail
	case symSpinnaker
	case asySpinnaker
}

protocol Sail {
	var area: Measurement<UnitArea> { get }
}

extension CGFloat {
	var round3: String {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 3
		return formatter.string(from: self as NSNumber)!
	}
}
