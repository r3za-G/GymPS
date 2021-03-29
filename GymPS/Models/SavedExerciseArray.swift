//
//  SavedExerciseArray.swift
//  GymPS
//
//  Created by Reza Gharooni on 29/03/2021.
//

import Foundation

struct SavedExerciseArray: Codable {
    var ExerciseArray: [ExerciseArray]
}

struct ExerciseArray: Codable {
    
    let name: String
    let muscleGroup: String
    let description: String
    
    init(name: String, muscleGroup: String, description: String){
        self.name = name
        self.muscleGroup = muscleGroup
        self.description = description
    }
}
