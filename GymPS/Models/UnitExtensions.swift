//
//  UnitExtensions.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import Foundation

//class to convert pace from different measurements

class PaceConverter: UnitConverter {
    private let coefficient: Double
    
    init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    private func reciprocal(_ value: Double) -> Double {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return reciprocal(baseUnitValue * coefficient)
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        return reciprocal(value * coefficient)
    }
    
}

//UnitSpeed is provided via Foundation
extension UnitSpeed {
    
    class var minutesPerMile: UnitSpeed {
        return UnitSpeed(symbol: "min/mi", converter: PaceConverter(coefficient: 60.0 / 1609.34))
    }
    class var minutesPerKilometer: UnitSpeed {
        return UnitSpeed(symbol: "min/km", converter: PaceConverter(coefficient: 60.0 / 1000.0))
    }
    
    class var secondsPerMeter: UnitSpeed {
        return UnitSpeed(symbol: "sec/m", converter: PaceConverter(coefficient: 1))
    }
}
