//
//  CaloriesHandler.swift
//  GymPS
//
//  Created by Reza Gharooni on 19/04/2021.
//

import Foundation

//struct to handle the callories burnt calculations
struct CaloriesHandler {
    
    var final: Double = 0.0
    
    // method to calculate the calories burnt when running
    
    mutating func caloriesBurnedRunning(avgSpeed: Double, bodyWeight: Double) -> Double {        //Takes in the speed and the weight of the user to calculate calories
        var MET: Double     //The MET's (Metabolic equivalents) are used to esimate the energy cost of the activity
        switch avgSpeed {
        case _ where avgSpeed <= 4.0:       // the met is determined on the speed of the user
            MET = 5
        case _ where avgSpeed <= 5.0:
            MET = 8.3
        case _ where avgSpeed <= 5.2:
            MET = 9
        case _ where avgSpeed <= 6.0:
            MET = 9.8
        case _ where avgSpeed <= 6.7:
            MET = 10.5
        case _ where avgSpeed <= 7.0:
            MET = 11
        case _ where avgSpeed <= 7.5:
            MET = 11.5
        case _ where avgSpeed <= 8.0:
            MET = 11.8
        case _ where avgSpeed <= 8.6:
            MET = 12.3
        case _ where avgSpeed <= 9.0:
            MET = 12.8
        case _ where avgSpeed <= 9.5:
            MET = 13.7
        case _ where avgSpeed <= 10.0:
            MET = 14.5
        case _ where avgSpeed <= 11.0:
            MET = 16
        case _ where avgSpeed <= 12.0:
            MET = 19
        case _ where avgSpeed <= 13.0:
            MET = 19.8
        case _ where avgSpeed <= 14.0:
            MET = 23
        default:
            MET = 24
        }
        
        
        let unit = UserDefaults.standard.string(forKey: "Unit")     //see what unit the user has chosen for their weight
        
        if unit == "kg"{
            final = (MET * bodyWeight * 3.5) / 200.0
            
        }
        if unit == "lb"{
            final = (MET * (bodyWeight / 2.25) * 3.5) / 200.0 //  divide by 2.25 because weight given in pounds
        }
        
        return (final/60.0)/2      // final calories calculated
    }
    
    // method to calculate the calories burnt when cycling
    mutating func caloriesBurntCycling(avgSpeed: Double, bodyWeight: Double) -> Double {
        var MET: Double
        switch avgSpeed {
        case _ where avgSpeed <= 5.5:
            MET = 3.5
        case _ where avgSpeed <= 9:
            MET = 5.8
        case _ where avgSpeed <= 12:
            MET = 6.8
        case _ where avgSpeed <= 14:
            MET = 8
        case _ where avgSpeed <= 17:
            MET = 10.5
        case _ where avgSpeed <= 19:
            MET = 12
        case _ where avgSpeed <= 21:
            MET = 13.5
        case _ where avgSpeed <= 23:
            MET = 15.8
        default:
            MET = 16.5
        }
        
        let unit = UserDefaults.standard.string(forKey: "Unit")
        
        if unit == "kg"{
            final = (MET * bodyWeight * 3.5) / 200.0
            
        }
        if unit == "lb"{
            final = (MET * (bodyWeight / 2.25) * 3.5) / 200.0 //  divide by 2.25 because weight given in pounds
        }
        
        return (self.final/60.0)/2
    }
    
}
