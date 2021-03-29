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
    var workoutArray = [Workout]()
    var workout: Workout!
   
    
    var exerciseSetsArray: [(name: String, sets: Int)]?
    var workoutName: String?
    var setsArraySent: [Int]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var exerciseNameArray = [String]()
    var setsArray = [Int]()
    var exerciseArray = [(name: String, sets: Int)]()
    
    func loadWorkout() -> [Workout]?{
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        do{
            workoutArray = try context.fetch(request)
            return workoutArray
        }catch {
            print("error fetching data \(error)")
        }
        return workoutArray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0{
            return 1
        }else if section == 1{
            return Int(workout.amountOfExercises)
        } else{
            return 1
        }
        
    }
    
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
        
        
        
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutNameCell", for: indexPath)
            cell.textLabel?.text = workout.name
            cell.textLabel?.textColor = UIColor.white
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath)
            cell.textLabel?.text = exerciseNameArray[indexPath.row]
            
            if setsArray[indexPath.row] == 1{
                cell.detailTextLabel?.text = "\(setsArray[indexPath.row]) set"
            } else{
                cell.detailTextLabel?.text = "\(setsArray[indexPath.row]) sets"
            }
            
            cell.isEditing = true
            self.tableView.isEditing = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalsCell", for: indexPath)
            cell.textLabel?.text = "Total exercises: \(workout.amountOfExercises)"
            cell.detailTextLabel?.text = "Total sets: \(setsArray.sum())"
            cell.isEditing = false
            self.tableView.isEditing = false
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let exericeToMove = exerciseArray[sourceIndexPath.row]
        
        exerciseArray.remove(at: sourceIndexPath.row)
        exerciseArray.insert(exericeToMove, at: destinationIndexPath.row)
//        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "StartWorkoutTableViewController"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let setsStringAsData = workout.sets!.data(using: String.Encoding.utf16)
        self.setsArray = try! JSONDecoder().decode([Int].self, from: setsStringAsData!)
        
        let exerciseStringAsData = workout.exerciseNames!.data(using: String.Encoding.utf16)
        self.exerciseNameArray = try! JSONDecoder().decode([String].self, from: exerciseStringAsData!)
        
        
        for i in zip(exerciseNameArray, setsArray){
            self.exerciseArray.append((name: i.0, sets: i.1))
        }
        
        self.workoutName = workout.name
        self.setsArraySent = setsArray
    
    }
    
    @IBAction func startWorkoutPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: .details, sender: nil)
    }
    
    
}


extension StartWorkoutTableViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "StartWorkout"
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            switch segueIdentifier(for: segue) {
            case .details:
                let destination = segue.destination as! DoWorkoutViewController
                
                destination.workoutName = workoutName
                destination.setsArray = setsArraySent
                destination.exerciseSetsArray = exerciseArray
     
            }
        
    }
}
