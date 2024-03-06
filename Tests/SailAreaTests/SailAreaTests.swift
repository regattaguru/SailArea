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

		let tokolosheMain = Mainsail(
			/// Measurement<UnitLength> has been extended to be ExpresibleByFloatLiteral if the unit is metres
			luff: 12.54,
			foot: 4.5,
			leech: 13.0,
			headWidth: 1.1,
			upperWidth: 1.61,
			threeQuarterWidth: 2.11,
			halfWidth: 3.05,
			quarterWidth: 3.81
		)
		XCTAssertEqual(tokolosheMain.area, Measurement(value: 36.90678749999999, unit: .squareMeters))
		let home = ("~/xcode" as NSString).expandingTildeInPath
		let docDir = URL(fileURLWithPath: home)
		let url = docDir.appendingPathComponent("TokolosheMain.pdf")
		tokolosheMain.pdfProfile(url: url)


			// Defining Test Cases and Test Methods
			// https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
	}
	
	func testMainArea2() {
		let jeffertjeMain = Mainsail(
			luff: Measurement(value: 18.65, unit: .meters),
			foot: Measurement(value: 6.66, unit: .meters),
			leech: Measurement(value: 0, unit: .meters),
			headWidth: Measurement(value: 0.24, unit: .meters),
			upperWidth: Measurement(value: 1.4, unit: .meters),
			threeQuarterWidth: Measurement(value: 2.5, unit: .meters),
			halfWidth: Measurement(value: 4.3, unit: .meters),
			quarterWidth: Measurement(value: 5.6, unit: .meters)
		)
		XCTAssertEqual(jeffertjeMain.area.value.roundTo2(), 73.97)
		let home = ("~/xcode" as NSString).expandingTildeInPath
		let docDir = URL(fileURLWithPath: home)
		let url = docDir.appendingPathComponent("JeffertjeMain.pdf")
		jeffertjeMain.pdfProfile(url: url)
	}
}
