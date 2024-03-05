//
//  Mainsail+PDF.swift
//  
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation
import CoreText

extension Mainsail {
	func leechProfile() -> CGMutablePath? {
		let pts = leechPoints
		let cpArray = BezierSpline.getCurveControlPoints(knots: pts)

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
			path.addCurve(to: ptArray[i], control1: cpArray[i].0, control2: cpArray[i].1)
		}
		for i in 0..<pts.endIndex {
			path.move(to: pts[i])
			path.addLine(to: CGPoint(x: 0, y: pts[i].y))
			path.closeSubpath()
		}
		return path
	}

	func pdfProfile(url: URL) {
			// Letter: 612 by 792
			// A4:     595 by 842
		var mediaBox = CGRect(origin: CGPoint.zero, size: CGSize(width: 595, height: 842))

		guard let context = CGContext(url as CFURL, mediaBox: &mediaBox , nil) else {
			return
		}
		guard let path = leechProfile() else { return }
		let h = path.boundingBox.height
		let sc = (mediaBox.height - 60) / h

		context.beginPDFPage(nil)
		context.translateBy(x: path.boundingBox.width * sc / 2 + mediaBox.width/2, y: 30)
			// Backwards sail just looks so wrong... Hence mirroring on Y axis
		context.scaleBy(x: -sc, y: sc)
		context.addPath(path)

		context.setStrokeColor(.init(red: 1, green: 0, blue: 0, alpha: 1))
		context.setLineWidth(1/sc)
		context.drawPath(using: .stroke)

		context.scaleBy(x: -1, y: 1)
		for g in self.leechPoints {
			let frame = makeFrame(
				str: "\(g.x.round3) →",
				point: .init(x: -g.x - 0.1, y: g.y),
				align: .trailing
			)
			context.addFrame(frame)
			context.addFrame(
				makeFrame(
					str: g.y != 0 ? "← • ↓ \(g.y.round3)" : "← • ↑ 0",
					point: .init(x: 0.1, y: g.y)
				)
			)

		}
		context.addFrame(
			makeFrame(
				str: measFormatter.string(from: self.area),
				point: .init(x: -foot.value/2, y: luff.value/2)
			)
		)

		context.endPDFPage()
		context.closePDF()
	}
}
