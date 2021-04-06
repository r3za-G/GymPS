//
//  ExerciseData.swift
//  GymPS
//
//  Created by Reza Gharooni on 08/03/2021.
//

import Foundation

//Struct for our exercise data
struct ExerciseData: Codable{
    let Exercises: [Exercises]
}

//Exercises struct for the JSON data to be decoded
struct Exercises: Codable {
    let id: String
    let name: String
    let muscleGroup: String
    let description: String
    let last_modified: String

}
