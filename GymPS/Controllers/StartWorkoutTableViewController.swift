//
//  StartExerciseTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit
import CoreData

class StartWorkoutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var exercises = 0
    var workoutArray = [CreateWorkout]()    //instance for the core data entity
    var workout: CreateWorkout!             //instance for the core data entity
   
    
    var exerciseSetsArray: [(name: String, sets: Int)]?
    var workoutName: String?
    var setsArraySent: [Int]?
    var exerciseNameArraySent: [String]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //exercise data arrays
    var exerciseNameArray = [String]()
    var setsArray = [Int]()
    var exerciseArray = [(name: String, sets: Int)]()
    
    //loads the workouts from core data
    func loadWorkout() -> [CreateWorkout]?{
        let request: NSFetchRequest<CreateWorkout> = CreateWorkout.fetchRequest()
        do{
            workoutArray = try context.fetch(request)
            return workoutArray
        }catch {
            print("error fetching data \(error)")
        }
        return workoutArray
    }
    
    //returns number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    //returns amount of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if statement to return how many rows for each section
        if section == 0{
            return 1
        }else if section == 1{
            return Int(workout.amountOfExercises)
        } else{
            return 1
        }
        
    }
    //returns titles for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return("Workout Name")
        case 1:
            return("Exercises")
        case 2:
            return("Totals")
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //return cell data for first section
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutNameCell", for: indexPath)
            cell.textLabel?.text = workout.name //workout name
            cell.textLabel?.textColor = UIColor.white
            
            let dateFormat = DisplayFormatter.date(workout.created)   //formats date

            cell.detailTextLabel?.text = "Created on: \(dateFormat)"   //returns the date the workout was created on
            cell.detailTextLabel?.textColor = UIColor.white
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0)
            return cell
            
        } else if indexPath.section == 1{   //section two of three
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath)
            cell.textLabel?.text = exerciseNameArray[indexPath.row] //returns the exercises the user selected for this workout
            
            if setsArray[indexPath.row] == 1{   //if statement to return singular/ plural set(s) if the user chosen 1 or 2 sets for an exercise.
                cell.detailTextLabel?.text = "\(setsArray[indexPath.row]) set"
            } else{
                cell.detailTextLabel?.text = "\(setsArray[indexPath.row]) sets"
            }
            
            cell.isEditing = true   //allows the cells to be edited (re-shuffled in order)
            self.tableView.isEditing = true
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalsCell", for: indexPath) //last section of the cells displays the total amount of exericses and sets for the workout
            cell.textLabel?.text = "Total exercises: \(workout.amountOfExercises)"
            cell.detailTextLabel?.text = "Total sets: \(setsArray.sum())"
            cell.isEditing = false      //these cells are not allowed to be re-shuffled
            self.tableView.isEditing = false
            return cell
        }
    }
    
    //function to allow usewr to move the cells at different index rows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    //no indenting when the cells move
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    //shows where the chosen cells should be removed/placed
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let exericeToMove = exerciseArray[sourceIndexPath.row]
        
        exerciseArray.remove(at: sourceIndexPath.row)
        exerciseArray.insert(exericeToMove, at: destinationIndexPath.row)

        
    }
    
    //returns the index path for the target row where the cell should move to.
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section { //reveals that only the second section should be able to edit and move cells
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "StartWorkoutTableViewController"
        
        //sets the navigation bar colour to be white
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //decodes the saved string array from core data
        //The array was saved as a string and here it is decoded to become it's original data form, an integer array
        let setsStringAsData = workout.sets!.data(using: String.Encoding.utf16)
        self.setsArray = try! JSONDecoder().decode([Int].self, from: setsStringAsData!)
        
        //decodes the saved string array from core data
        //The array was saved as a string and here it is decoded to become it's original data form, an string array
        let exerciseStringAsData = workout.exerciseNames!.data(using: String.Encoding.utf16)
        self.exerciseNameArray = try! JSONDecoder().decode([String].self, from: exerciseStringAsData!)
        
        //uses the zip function to merge two arrays into one
        for i in zip(exerciseNameArray, setsArray){
            self.exerciseArray.append((name: i.0, sets: i.1))
        }
        
        self.workoutName = workout.name
        self.setsArraySent = setsArray
        self.exerciseNameArraySent = exerciseNameArray
       
    
    }
    //IBAction to send the user to the DoWorkoutViewController when they press the start button
    @IBAction func startWorkoutPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: .details, sender: nil)
    }
    
    
}

//MARK: - Segue Handler
extension StartWorkoutTableViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "StartWorkout"
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            switch segueIdentifier(for: segue) {
            case .details:
                let destination = segue.destination as! DoWorkoutViewController
                //sends the following data to DoWorkoutViewController using segue
                destination.workoutName = workoutName
                destination.setsArray = setsArraySent
                destination.exerciseSetsArray = exerciseArray
                destination.exerciseNameArray = exerciseNameArraySent
     
            }
        
    }
}
