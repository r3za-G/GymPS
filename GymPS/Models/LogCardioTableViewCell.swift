//
//  LogTableViewCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import Foundation
import UIKit
import CoreData

class LogCardioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardioType: UIImageView!
    
    var cardio: Cardio? {
        didSet {
            updateViews()
        }
    }

    
     func updateViews() {

        
        guard let cardio = cardio else { return }
        
        let distanceTravelled = Measurement(value: cardio.distance, unit: UnitLength.meters)
        let seconds = cardio.duration
        let date = cardio.timestamp
        let formattedDistance = FormatDisplay.distance(distanceTravelled)
        let caloriesBurnt = Int(cardio.calories.rounded())
        let formattedDate = FormatDisplay.date(date)
        let formattedTime = FormatDisplay.time(Int(seconds))
        let averagePace = String(format: "%.2f", cardio.averagePace)
        
        let cardioTypeString = cardio.cardioiType
        if cardioTypeString == "Running"{
            cardioType.image = UIImage(named: "runner")
        } else if cardioTypeString == "Cycling"{
            cardioType.image = UIImage(named: "bicycle-rider")
        }

        distanceLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        paceLabel.text = "\(averagePace)"
        calorieLabel.text = "\(caloriesBurnt) kcal"
        dateLabel.text = "\(formattedDate)"
    }
}
    
    
