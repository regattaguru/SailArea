//
//  String-extensions.swift
//  
//
//  Created by Paul Miller on 2024-02-29.
//

import Foundation

extension NSMutableAttributedString {
	func defaultBBox() -> CGRect{
		self.boundingRect(with: CGSize.zero, options: .ArrayLiteralElement(), context: nil)
	}
	var defaultSize: CGSize {
		self.defaultBBox().size
	}
}

