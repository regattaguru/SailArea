//
//  Measurement+ext.swift
//
//
//  Created by Paul Miller on 2024-03-06.
//

import Foundation

extension Measurement<UnitLength>: ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Double
	public init(floatLiteral value: Double) {
		self.init(value: value, unit: .meters)
	}
}
