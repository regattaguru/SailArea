# SailArea

A Swift package with tools for handling sail area calculations and visualisation. 

## Caveats

The package is now, and probably always will be very lightweight. But it does contain very well-tested calculations for sail area, and is therefore useful for anyone writing a rating system or possibly a naval architect. Sailmakers have access to even better formulas from their own lofts.

The package uses `Measurement<UnitLength>` and `Measurement<UnitArea>` types. This makes the system unit-agnostic, and by default outputs will follow the Locale settings of the user.

The bezier paths of the sail profiles are available for easy integration into a `CGContext` for flexible display and PDF production.

Finally: commenting and documentation are sporadic.

## Usage

SPM: Add https://github.com/regattaguru/SailArea.git as a package.

```swift
import SailArea

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
if let docDir = try? FileManager.default.url(
		for: .documentDirectory, 
		in: .userDomainMask, 
		appropriateFor: nil, 
		create: false) {
	let url = docDir.appendingPathComponent("TokolosheMain.pdf")
	tokolosheMain.pdfProfile(url: url)
}
```
