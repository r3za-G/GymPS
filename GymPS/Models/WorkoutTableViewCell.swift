//
//  WorkoutTableViewCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//
import Foundation
import UIKit
import CoreData

class WorkoutTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var numberOfExercises: UILabel!
    
    
    var workout: CreateWorkout? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {

       guard let workout = workout else { return }
        
        let workoutNames = workout.name
        let numberOfExercise = workout.amountOfExercises
        
        workoutName.text = workoutNames
        numberOfExercises.text = "\(numberOfExercise) Exercises"
       
    }
}
