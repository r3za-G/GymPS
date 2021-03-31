//
//  LogWorkoutTableCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 31/03/2021.
//

import Foundation
import UIKit
import CoreData

class LogWorkoutTableCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dumbbellImage: UIImageView!
    
    var workout: Workout? {
        didSet {
            updateViews()
            
        }
    }
    
    
    func updateViews() {

       guard let workout = workout else { return }
        
        
        let formattedDate = FormatDisplay.date(workout.dateCompleted)
        let name = workout.workoutName ?? ""
            
        
        nameLabel.text = "\(name)"
        dateLabel.text = "\(formattedDate)"
        dumbbellImage.image = UIImage(named: "Workout")
    
        
    }
}
