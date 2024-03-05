//
//  CTFont+extensions.swift
//
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation
import CoreText

/// Helpers to make CoreText just a little more Swifty
extension CTFont {
		/// Returns the scaled font-ascent metric of the given font.
	var ascent: CGFloat { CTFontGetAscent(self) }
		/// Returns the scaled font-descent metric of the given font.
	var descent: CGFloat { CTFontGetDescent(self) }
		/// Returns the scaled font-leading metric of the given font.
	var leading: CGFloat { CTFontGetLeading(self) }
		/// Returns the units-per-em metric of the given font.
	var unitsPerEm: UInt32 { CTFontGetUnitsPerEm(self) }
		/// Returns the number of glyphs of the given font.
	var glyphCount: CFIndex { CTFontGetGlyphCount(self) }
		/// Returns the scaled bounding box of the given font.
	var boundingBox: CGRect { CTFontGetBoundingBox(self) }
		/// Returns the scaled underline position of the given font.
	var underlinePosition: CGFloat { CTFontGetUnderlinePosition(self) }
		/// Returns the scaled underline-thickness metric of the given font.
	var underlineThickness: CGFloat { CTFontGetUnderlineThickness(self) }
		/// Returns the slant angle of the given font.
	var slantAngle: CGFloat { CTFontGetSlantAngle(self) }
		/// Returns the cap-height metric of the given font.
	var capHeight: CGFloat { CTFontGetCapHeight(self) }
		/// Returns the x-height metric of the given font.
	var xHeight: CGFloat { CTFontGetXHeight(self) }
}
