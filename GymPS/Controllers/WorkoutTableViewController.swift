//
//  WorkoutTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit
import CoreData

class WorkoutTableViewController: UITableViewController {
 
  
    @IBOutlet var workoutTable: UITableView!
 
    
    var workoutsArray = [Workout]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var indexRowSelected = 0
    
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
    
    
    @IBAction func createWorkoutButton(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: .detailsTwo, sender: nil)
        
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
        
        return 1
}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadWorkouts()?.count == 0{
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
        
        let sortedWorkouts = workouts.sorted(by: { $0.name! < $1.name! })
        let workout = sortedWorkouts[indexPath.row]
        

        cell.workout = workout
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexRowSelected = indexPath.row

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
    
extension WorkoutTableViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case detailsOne = "StartWorkout"
        case detailsTwo = "CreateWorkout"
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let indexPath = workoutTable.indexPathForSelectedRow
            switch segueIdentifier(for: segue) {
            case .detailsOne:
                let destination = segue.destination as! StartWorkoutTableViewController
    
                destination.workout = workoutsArray.sorted(by: { $0.name! < $1.name! })[indexPath!.row]
                
            case .detailsTwo:
                _ = segue.destination as! NewWorkoutViewController
            }
        
    }
}


