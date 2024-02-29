import XCTest
@testable import SailArea

extension Double {
	func roundTo2() -> Double {
		return (self * 100).rounded(.toNearestOrAwayFromZero) / 100
	}
}

final class SailAreaTests: XCTestCase {
	func testMainArea1() throws {
			// XCTest Documentation
			// https://developer.apple.com/documentation/xctest

		let tokaloshe = Mainsail(
			luff: Measurement(value: 12.54, unit: .meters),
			foot: Measurement(value: 4.5, unit: .meters),
			leech: Measurement(value: 13, unit: .meters),
			headWidth: Measurement(value: 1.1, unit: .meters),
			upperWidth: Measurement(value: 1.61, unit: .meters),
			threeQuarterWidth: Measurement(value: 2.11, unit: .meters),
			halfWidth: Measurement(value: 3.05, unit: .meters),
			quarterWidth: Measurement(value: 3.81, unit: .meters)
		)
		XCTAssertEqual(tokaloshe.area, Measurement(value: 36.90678749999999, unit: .squareMeters))
		let url = URL(fileURLWithPath: "/Users/millerp/xcode/tokaloshe.pdf")
		tokaloshe.pdfProfile(url: url)

			// Defining Test Cases and Test Methods
			// https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
	}
	
	func testMainArea2() {
		let jeffertje = Mainsail(
			luff: Measurement(value: 18.65, unit: .meters),
			foot: Measurement(value: 6.66, unit: .meters),
			leech: Measurement(value: 0, unit: .meters),
			headWidth: Measurement(value: 0.24, unit: .meters),
			upperWidth: Measurement(value: 1.4, unit: .meters),
			threeQuarterWidth: Measurement(value: 2.5, unit: .meters),
			halfWidth: Measurement(value: 4.3, unit: .meters),
			quarterWidth: Measurement(value: 5.6, unit: .meters)
		)
		XCTAssertEqual(jeffertje.area.value.roundTo2(), 73.97)
		let url = URL(fileURLWithPath: "/Users/millerp/xcode/jeffertje.pdf")
		jeffertje.pdfProfile(url: url)
	}
}
