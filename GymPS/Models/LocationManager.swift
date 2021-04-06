//
//  LocationManager.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import CoreLocation

//To have only one instance of Location Manager in GymPS
class LocationManager {
  static let shared = CLLocationManager()
  
  private init() { }
}
