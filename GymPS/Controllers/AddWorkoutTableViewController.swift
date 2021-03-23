//
//  AddWorkoutTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit

class AddWorkoutTableViewController: UITableViewController, SelectedExercisesDelegate, SegueHandlerType{
    

    
    @IBOutlet var exerciseNameTable: UITableView!

    
    private var exercise = [Exercise]()
    
    var selectedExercises: [String] = []

    
    var test = ""
    
    var exercisesAdded = AddExerciseTableViewController()
    
   
    override func viewDidLoad() {
         super.viewDidLoad()
     view.accessibilityIdentifier = "AddWorkoutTableViewController"
        
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
            var exercisesSelector = segue.destination as! AddExerciseTableViewController
            exercisesSelector.delegate = self
        }
    }
    
    @IBAction func addExercisesPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "AddSelectedExercises", sender: nil)
        
    }
    
    
    func didLoadSelectedExercises(exercises: [String]) {
        
        self.selectedExercises = exercises
        print(selectedExercises)
     

    }
    
    
   
    
    
    
    
    @IBAction func workoutName(_ sender: UITextField) {
    }
    
    
    @IBAction func saveWorkout(_ sender: UIButton) {
    }
    
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1 + min(exercise.count, 1)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if exercise.count == 0{
            return 2
        }else {
            return 3
        }
}

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return ("Name")
        default:
            return nil
    }
}
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if exercise.count == 0 && indexPath.section == 0 {
//             return tableView.dequeueReusableCell(withIdentifier: "addExerciseCell", for: indexPath)
//        }
       

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutNameCell", for: indexPath)
            return cell
        }
//        if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath)
//            cell.textLabel!.text = selectedExercises[indexPath.row]
//            return cell
//        }g
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addExerciseCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addExerciseCell", for: indexPath)
            return cell
        }
    }

}




  
