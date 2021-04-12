//
//  File.swift
//  GymPS
//
//  Created by Reza Gharooni on 10/04/2021.
//

import Foundation


import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var savedExerciseArray: [ExerciseData]?

}

extension Exercise : Identifiable {

}
