//
//  LogWorkoutTableCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 31/03/2021.
//

import Foundation
import UIKit
import CoreData

//custom cell for the log workout cell
class LogWorkoutTableCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dumbbellImage: UIImageView!
    
    //create a workout instance from coredata
    var workout: Workout? {
        didSet {
            updateViews()      
        }
    }
    
    //function to update the views
    func updateViews() {
        
        //create a workout instance from coredata
       guard let workout = workout else { return }
        
        //format date and name for the workout
        let dateFormatted = FormatDisplay.date(workout.dateCompleted)
        let name = workout.workoutName ?? ""
             
        //set the labels for the name and date
        nameLabel.text = "\(name)"
        dateLabel.text = "\(dateFormatted)"
        dumbbellImage.image = UIImage(named: "dumbbell")    //set the ui image to be a dumbbell to represent a weightlifting exercise
        dumbbellImage.tintColor = UIColor.white
    
        
    }
}
