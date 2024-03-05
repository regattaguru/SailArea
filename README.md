# SailArea

A Swift package with tools for handling sail area calculations and visualisation. 

### Caveats

The package is now, and probably always will be very lightweight. But it does contain very well-tested calculations for sail area, and is therefore useful for anyone writing a rating system or possibly a naval architect. Sailmakers have access to even better formulas from their own lofts.

The package uses `Measurement<UnitLength>` and `Measurement<UnitArea>` types. This makes the system unit-agnostic, and by default outputs will follow the Locale settings of the user.

The bezier paths of the sail profiles are available for easy integration into a `CGContext` for flexible display and PDF production.

Finally: commenting and documentation are sporadic.

### Usage

SPM: Add https://github.com/regattaguru/SailArea.git as a package.

```swift
import SailArea

let tokalosheMain = Mainsail(
	luff: Measurement(value: 12.54, unit: .meters),
	foot: Measurement(value: 4.5, unit: .meters),
	leech: Measurement(value: 13, unit: .meters),
	headWidth: Measurement(value: 1.1, unit: .meters),
	upperWidth: Measurement(value: 1.61, unit: .meters),
	threeQuarterWidth: Measurement(value: 2.11, unit: .meters),
	halfWidth: Measurement(value: 3.05, unit: .meters),
	quarterWidth: Measurement(value: 3.81, unit: .meters)
)

let mainArea: Measurement<UnitArea> = tokalosheMain.area
let url = URL(fileURLWithPath: "/Users/someuser/tokaloshe.pdf")
tokalosheMain.pdfProfile(url: url)
```
