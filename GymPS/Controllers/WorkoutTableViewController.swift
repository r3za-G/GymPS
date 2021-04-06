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
 
    
    var workoutsArray = [CreateWorkout]()
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
    
    //IBAction for the user to create their own workout
    @IBAction func createWorkoutButton(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: .detailsTwo, sender: nil)
        
    }
    
    
    func updateTheTable() {
        workoutTable.reloadData()
    }
    
    
    
    //function to load the user's saved workouts
    func loadWorkouts() -> [CreateWorkout]?{
        let request: NSFetchRequest<CreateWorkout> = CreateWorkout.fetchRequest()
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
    //returns the amount of saved exercises the user has
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadWorkouts()?.count == 0{
            return 1
        }else{
        return loadWorkouts()?.count ?? 0
    }
}

    
    //returns the data for each workout in their respective cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if their are no saved exercises, it returns a cell that displays "No Workouts"
        if loadWorkouts()?.count == 0  {
            return tableView.dequeueReusableCell(withIdentifier: "noWorkoutsCell", for: indexPath)
        }
        
        guard
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutsCell", for: indexPath) as? WorkoutTableViewCell,
            let workouts = loadWorkouts() //set the loaded workout array
        else { return UITableViewCell() }
        
        
            
            let sortedWorkouts = workouts.sorted(by: { $0.name ?? "" < $1.name ?? "" }) //sort the workouts in alphabetical order
            let workout = sortedWorkouts[indexPath.row]
 
            cell.workout = workout

        return cell     //returns the workouts
    }
    
    //function to show which index the user selected the workout at
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexRowSelected = indexPath.row
    }
    
    //function to save the workouts
    func saveWorkouts(){
        do{
            try context.save()
        } catch{
            print("error saving runs \(error)")
        }
        self.updateTheTable()
    }


    //editing function to allow the user to delete any exercise they don't want to have saved to core data
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard var workouts = loadWorkouts() else { return }
            context.delete(workouts[indexPath.row]) //deletes the workout from core data
            workouts.remove(at: indexPath.row)
            tableView.reloadData()
            saveWorkouts() //saves the remaining workouts
        }
    }
}
    
//extension handler for the segues to different view controllers
extension WorkoutTableViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case detailsOne = "SelectWorkout"
        case detailsTwo = "CreateWorkout"
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let indexPath = workoutTable.indexPathForSelectedRow
            switch segueIdentifier(for: segue) {
            case .detailsOne:
                let destination = segue.destination as! StartWorkoutTableViewController
                //this sends the selected workout and it's data to the StartWorkoutTableViewController
                destination.workout = workoutsArray.sorted(by: { $0.name! < $1.name! })[indexPath!.row]
                
            case .detailsTwo:
                _ = segue.destination as! NewWorkoutViewController
            }
        
    }
}


