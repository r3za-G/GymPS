//
//  FormatDisplay.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import Foundation

struct FormatDisplay {
    
  static func distance(_ distance: Double) -> String {
    let distanceMeasurement = Measurement(value: distance, unit: UnitLength.miles)
    return FormatDisplay.distance(distanceMeasurement)
  }
  
  static func distance(_ distance: Measurement<UnitLength>) -> String {
    let distanceFormatter = MeasurementFormatter()
    return distanceFormatter.string(from: distance)
  }
  
  static func time(_ seconds: Int) -> String {
    let timeFormatter = DateComponentsFormatter()
    timeFormatter.allowedUnits = [.hour, .minute, .second]
    timeFormatter.unitsStyle = .positional
    timeFormatter.zeroFormattingBehavior = .pad
    return timeFormatter.string(from: TimeInterval(seconds))!
  }
  
  static func pace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
    let paceFormatter = MeasurementFormatter()
    paceFormatter.unitOptions = [.providedUnit] // 1
    let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
    let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
    return paceFormatter.string(from: speed.converted(to: outputUnit))
  }
  
  static func date(_ timestamp: Date?) -> String {
    guard let timestamp = timestamp as Date? else { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter.string(from: timestamp)
  }
}
