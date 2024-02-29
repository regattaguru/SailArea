//
//  Mainsail+PDF.swift
//  
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation
import CoreText

@available(macOS 10.15, *)
extension Mainsail {
	@available(macOS 12.0, *)
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
				str: self.area.formatted(.measurement(width: .abbreviated, usage: .asProvided)),
				point: .init(x: -foot.value/2, y: luff.value/2)
			)
		)

		context.endPDFPage()
		context.closePDF()
	}
}
