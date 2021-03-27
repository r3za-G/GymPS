//
//  File.swift
//  GymPS
//
//  Created by Reza Gharooni on 25/03/2021.
//

import Foundation
import UIKit
import CoreData

class Workout: NSManagedObject, Equatable{
    
    @NSManaged var exerciseNames: [String]
}
