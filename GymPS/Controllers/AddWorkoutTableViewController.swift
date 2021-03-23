//
//  AddWorkoutTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit


class NameTableCell: UITableViewCell{
    
    @IBOutlet var workoutNameTextField: UITextField!
}

class ExercisesTableCell: UITableViewCell{
}

class AddExercisesTableCell: UITableViewCell{
}

class AddWorkoutTableViewController: UITableViewController, SelectedExercisesDelegate, SegueHandlerType, UITextFieldDelegate{
    
    
    
    @IBOutlet var exerciseNameTable: UITableView!
    
    
    private var exercise = [Exercise]()
    
    var selectedExercises: [String] = []
    
    var delegateExercises: [String] = []
    
    var workoutName: String = ""
    
    @IBOutlet var workoutTable: UITableView!
    

    var nameTableCell = NameTableCell()
    
    var exercisesAdded = AddExerciseTableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "AddWorkoutTableViewController"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.black
        
    
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    enum SegueIdentifier: String {
        case details = "AddSelectedExercises"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        exercisesAdded.delegate = self
        switch segueIdentifier(for: segue) {
        case .details:
            let exercisesSelector = segue.destination as! AddExerciseTableViewController
            exercisesSelector.delegate = self
        }
    }
    
    @IBAction func addExercisesPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "AddSelectedExercises", sender: nil)
        
    }
    
    
    func didLoadSelectedExercises(exercises: [String]) {
        
        self.delegateExercises = exercises
        
        
        self.updateTheTable()
        
        updatedExercisesArray()
   
    }
    
    
    func updateTheTable() {
        workoutTable.reloadData()
    }
    
    func updatedExercisesArray() {
        
        self.selectedExercises.append(contentsOf: delegateExercises)
        
        print(selectedExercises)
        self.updateTheTable()
        
    }
    
    
    
    
    
    
    
    @IBAction func workoutName(_ sender: UITextField) {
        
        self.nameTableCell.workoutNameTextField?.text = workoutName
        
        print(workoutName)
        
    }
    
    
    @IBAction func saveWorkout(_ sender: UIButton) {
    }
    
    
    
    // MARK: - Table view data source
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            if selectedExercises.count == 0{
                return 0
            } else {
                return selectedExercises.count
            }
        }else {
            return 1
        }
        
    
}

    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return ("Name")
        case 1:
            return("Exercises")
        default:
            return nil
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutNameCell", for: indexPath) as! NameTableCell
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExercisesTableCell
            if selectedExercises.isEmpty{
                return cell
            }else{
                cell.textLabel!.text = selectedExercises[indexPath.row]
            }
            return cell
}
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addExerciseCell", for: indexPath) as! AddExercisesTableCell
            return cell
            
        }
    }
}





