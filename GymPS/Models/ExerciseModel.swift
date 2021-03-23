//
//  ExerciseModel.swift
//  GymPS
//
//  Created by Reza Gharooni on 08/03/2021.
//

import Foundation



struct ExerciseModel {
    
    let Exercises: [Exercises]
}

struct Exercises {
    let id: String
    let name: String
    let muscleGroup: String
    let description: String
    let last_modified: String
}
