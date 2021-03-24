//
//  ExercisesTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit
import CoreData

class WorkoutTableViewController: UITableViewController {
 
  
    @IBOutlet var workoutTable: UITableView!
    @IBOutlet weak var addWorkout: UIBarButtonItem!
    
    var workoutsArray = [Workout]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
         super.viewDidLoad()
     view.accessibilityIdentifier = "WorkoutTableViewController"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        

     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheTable()
        
        
    }
    
    
    func updateTheTable() {
        workoutTable.reloadData()
    }
    
    
    func loadWorkouts() -> [Workout]?{
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        do{
            workoutsArray = try context.fetch(request)
            return workoutsArray.reversed()
        }catch {
            print("error fetching data \(error)")
        }
        return workoutsArray
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if loadWorkouts()?.count == 0{
        return 1
        } else{
            return 1
        }
}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
            return loadWorkouts()?.count ?? 0
    }
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if loadWorkouts()?.count == 0  {
            return tableView.dequeueReusableCell(withIdentifier: "noWorkoutsCell", for: indexPath)
        }
        
        guard
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutsCell", for: indexPath) as? WorkoutTableViewCell,
            let workouts = loadWorkouts()
        else { return UITableViewCell() }
        
        let workout = workouts[indexPath.row]

        cell.workout = workout
  
        return cell
    }
    
    
    func saveWorkouts(){
        do{
            try context.save()
        } catch{
            print("error saving runs \(error)")
        }
        self.updateTheTable()
    }



    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard var workouts = loadWorkouts() else { return }
            context.delete(workouts[indexPath.row])
            workouts.remove(at: indexPath.row)
            tableView.reloadData()
            saveWorkouts()
        }
    }
}
    

