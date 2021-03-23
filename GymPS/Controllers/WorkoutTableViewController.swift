//
//  ExercisesTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit

class WorkoutTableViewController: UITableViewController {
    
   
   
    
  
    @IBOutlet weak var addWorkout: UIBarButtonItem!
    private var workouts = [Workout]()
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
     view.accessibilityIdentifier = "WorkoutTableViewController"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

     }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + min(workouts.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return max(workouts.count, 1)
        default:
            return 0
        }
}
    
    
 

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if workouts.count == 0 && indexPath.section == 0 {
                   return tableView.dequeueReusableCell(withIdentifier: "noWorkoutsCell", for: indexPath)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutsCell", for: indexPath)
        let workout = (indexPath.section == 0 ? workouts : workouts)[indexPath.row]
        cell.textLabel?.text = workout.name
        
        return cell
    }

}
