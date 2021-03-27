//
//  CustomPin.swift
//  GymPS
//
//  Created by Reza Gharooni on 25/03/2021.
//

import Foundation
import UIKit
import MapKit

class CustomPin: NSObject {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(pinTitle: String, location: CLLocationCoordinate2D){
        self.title = pinTitle
        self.coordinate = location
    }
}
