//
//  WorkoutTableViewCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//
import Foundation
import UIKit
import CoreData

//custom cell for workout tableview
class WorkoutTableViewCell: UITableViewCell {
    
    //custom labels for cell
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var numberOfExercises: UILabel!
    
    //creates an instance for the CreateWorkout entitiy in core data
    var workout: CreateWorkout? {
        didSet {
            updateViews()
        }
    }
    
    //function to update the views of the cell
    func updateViews() {
        //receives the data from coredata
       guard let workout = workout else { return }
        
        let workoutNames = workout.name
        let numberOfExercise = workout.amountOfExercises
        
        workoutName.text = workoutNames
        numberOfExercises.text = "\(numberOfExercise) Exercises"
       
    }
}
