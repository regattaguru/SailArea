//
//  BezierSpline.swift
//
//
//  Created by Paul Miller on 2024-02-27.
//  I am indebted to the authors of
//  https://www.codeproject.com/Articles/31859/Draw-a-Smooth-Curve-through-a-Set-of-2D-Points-wit

import Foundation
import CoreGraphics

class BezierSpline {
	/// Creates intermediate control points to smoothly connect the points provided.
	///
	/// - Parameters:
	/// 	- knots: An array of more than one points. An array of two points will return control points that define a straight line.
	///
	/// - Returns: An array of tuples containing the control points required. 
	///
	/// The array returned will be one element shorter than the array provided as the parameter. Each element of the returned array contains the two control points to insert between the corresponding knots.
	///
	static func getCurveControlPoints(knots: [CGPoint]) -> [(CGPoint,CGPoint)] {
		let segCount = knots.count - 1
		guard segCount > 0 else { fatalError("At least two knot points required") }

		if segCount == 1 {
			// Straight line
			let cp1 = CGPoint(x: (2 * knots[0].x + knots[1].x) / 3,
												y: (2 * knots[0].y + knots[1].y) / 3)
			let cp2 = CGPoint(x: 2 * cp1.x - knots[0].x,
												y: 2 * cp1.y - knots[0].y)
			return [(cp1,cp2)]
		}

		var xside: [Double] = Array(repeating: 0.0, count: segCount)
		var yside: [Double] = Array(repeating: 0.0, count: segCount)

		for i in 0..<segCount {
			switch i {
			case 0:
				xside[i] = knots[i].x + 2 * knots[i + 1].x
				yside[i] = knots[i].y + 2 * knots[i + 1].y
			case xside.endIndex - 1: // last segment
				xside[i] = (8 * knots[i].x + knots[i + 1].x) / 2.0
				yside[i] = (8 * knots[i].y + knots[i + 1].y) / 2.0
			default:
				xside[i] = 4 * knots[i].x + 2 * knots[i + 1].x
				yside[i] = 4 * knots[i].y + 2 * knots[i + 1].y
			}
		}

		let xSet = getFirstControlPoints(xside)
		let ySet = getFirstControlPoints(yside)

		var controlPoints: [(CGPoint,CGPoint)] = .init(repeating: (.zero,.zero), count: segCount)
		for i in 0..<segCount {
			controlPoints[i].0 = CGPoint(x: xSet[i], y: ySet[i])
			controlPoints[i].1 = switch i {
			case segCount - 1: // last segment
				CGPoint(x: (knots[i + 1].x + xSet[i]) / 2,
								y: (knots[i + 1].y + ySet[i]) / 2)
			default:
				CGPoint(x: 2.0 * knots[i + 1].x - xSet[i + 1],
								y: 2.0 * knots[i + 1].y - ySet[i + 1])
			}
		}
		return controlPoints
	}

	private static func getFirstControlPoints(_ rhs: [Double]) -> [Double] {
		let segCount = rhs.count
		var outArray = [Double](repeating: 0.0, count: segCount)
		var tempArray = [Double](repeating: 0.0, count: segCount)
		var b = 2.0
		outArray[0] = rhs[0] / b
		for i in 1..<segCount {
			tempArray[i] = 1 / b
			b = (i < segCount - 1 ? 4.0 : 3.5) - tempArray[i]
			outArray[i] = (rhs[i] - outArray[i - 1]) / b
		}
		for i in stride(from: segCount - 1, to: 0, by: -1) {
			outArray[i - 1] -= tempArray[i] * outArray[i]
		}
		return outArray
	}
}

