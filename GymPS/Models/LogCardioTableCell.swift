//
//  LogCardioTableCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 31/03/2021.
//



import Foundation
import UIKit
import CoreData

//custom cell for the cardio logs
class LogCardioTableCell: UITableViewCell {
    
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardioType: UIImageView!
    
    //create a cardio instance
    var cardio: Cardio? {
        didSet {
            updateViews() //call the updateViews func
        }
    }

    //function to set the labels and image for the cell
     func updateViews() {

        //create a cardio instance from core data
        guard let cardio = cardio else { return }
        
        //format the each of the data to be displayed to the user on the log view controller
        let distanceTravelled = Measurement(value: cardio.distance, unit: UnitLength.meters)
        let seconds = cardio.duration
        let date = cardio.timestamp
        let distanceFormatted = FormatDisplay.distance(distanceTravelled)
        let caloriesBurnt = Int(cardio.calories.rounded())
        let dateFormatted = FormatDisplay.date(date)
        let timeFormatted = FormatDisplay.time(Int(seconds))
        let averagePace = String(format: "%.2f", cardio.averagePace)
        
        //sets the image of the cardio type depending on the user's activity.
        let cardioTypeString = cardio.cardioiType
        if cardioTypeString == "Running"{
            cardioType.image = UIImage(named: "runner")
        } else if cardioTypeString == "Cycling"{
            cardioType.image = UIImage(named: "bicycle-rider")
        }
        
        //set the labels as interpolated strings
        distanceLabel.text = "\(distanceFormatted)"
        timeLabel.text = "\(timeFormatted)"
        paceLabel.text = "\(averagePace)"
        calorieLabel.text = "\(caloriesBurnt) kcal"
        dateLabel.text = "\(dateFormatted)"
    }
}
    
