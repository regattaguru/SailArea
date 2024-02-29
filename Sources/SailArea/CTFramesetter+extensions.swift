//
//  CTFramesetter+extensions.swift
//
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation
import CoreText

enum FrameAlign {
	case leading,center,trailing
}

enum FrameVAlign {
	case baseline,midX,xTop,top
}

extension CGContext {
	func addFrame(_ frame: CTFrame) {
		self.saveGState()
		CTFrameDraw(frame, self)
		self.restoreGState()
	}
}

extension CTFramesetter {
	func createFrame(path: CGPath, range: CFRange = CFRange(location: 0, length: 0)) -> CTFrame {
		return CTFramesetterCreateFrame(self,range,path,nil)
	}
}

func makeFrame(str: String,
							 point: CGPoint,
							 align: FrameAlign = .leading) -> CTFrame {
	let myString = NSMutableAttributedString(string: str)

	let fontM = CTFont(.label, size: 0.2).xHeight

		// Create the attributes and add them to the string
	myString.addAttribute(
		NSAttributedString.Key.font,
		value: CTFont(.label, size: 0.2),
		range: NSRange(location: 0, length: myString.length)
	)
	myString.addAttribute(
		.foregroundColor,
		value: CGColor.black, //CGColor.init(red: 0, green: 1, blue: 0.6, alpha: 0.9),
		range: NSRange(location: 0, length: myString.length)
	)
	var pt = point
	pt.y -= myString.size().height + fontM / 2
	switch align {
	case .trailing: pt.x -= myString.defaultSize.width
	case .center: pt.x -= myString.defaultSize.width / 2.0
	default: break
	}
	let myNewRect = CGRect(origin: pt, size: myString.defaultSize)
	let newPath = CGPath(
		rect: myNewRect, //boundingRect(with: .zero, options: .ArrayLiteralElement(), context: nil),
		transform: nil
	)
	let framesetter = CTFramesetterCreateWithAttributedString(myString)
	let frame = framesetter.createFrame(path: newPath) //CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), newPath, nil)
	return frame
}

