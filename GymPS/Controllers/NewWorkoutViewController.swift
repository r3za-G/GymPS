//
//  NewWorkoutViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 23/03/2021.
//

import Foundation
import UIKit
import CoreData


class ExerciseCell: UITableViewCell{
    
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var setsStepper: UIStepper!
    
    @IBAction func stepper(_ sender: UIStepper) {
        setsLabel.text = String(Int(sender.value))
        
        
    }
    
    
}

class NewWorkoutViewController: UIViewController, SelectedExercisesDelegate, SegueHandlerType, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    
    
    @IBOutlet var workoutNameTextField: UITextField!
    @IBOutlet var workoutTable: UITableView!
    
    
    
    private var workout = [Workout]()
    
    var selectedExercises: [String] = []
    
    var delegateExercises: [String] = []
    
    var workoutName: String = ""
    var numberOfSets = 0
    
    var exercisesSetsArray = [(Int)]()
    
    var finalSetsArray = [(Int)]()
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var exercisesAdded = AddExerciseTableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "AddWorkoutTableViewController"
        
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        configureTextfields()
        
        workoutNameTextField.attributedPlaceholder = NSAttributedString(string: "Workout Name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        
    }
    
    private func configureTextfields(){
        workoutNameTextField.delegate = self
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
        
        //        print(delegateExercises)
        //        print(sele)
        
        for exercises in delegateExercises{
            if !(selectedExercises.contains(exercises)){
                self.selectedExercises.append(exercises)
            }
        }
        self.updateTheTable()
        
    }
    
    
    @IBAction func workoutName(_ sender: UITextField) {
        
        self.workoutName = workoutNameTextField.text!
        
    }
    
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
        updateTheTable()
    }
    
    @IBAction func saveWorkout(_ sender: UIButton) {
        
        exercisesAndSetsHandler()
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
    
    @IBAction func setsStepper(_ sender: UIStepper) {
        
        self.updateTheTable()
        
    }
    
    
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedExercises.count == 0{
            return 0
        } else {
            return selectedExercises.count
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return("Exercises")
        default:
            return nil
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExerciseCell
        
        cell.setsStepper.accessibilityIdentifier = selectedExercises[indexPath.row]
        cell.setsStepper.addTarget(self, action: #selector(setsStepper(_:)), for: .valueChanged)
        cell.setsLabel.text = String(Int(cell.setsStepper.value))
        self.numberOfSets = Int(cell.setsLabel.text!)!
        
        
        self.exercisesSetsArray.append((Int)(cell.setsStepper.value))
        
        
        self.finalSetsArray.append(contentsOf: self.exercisesSetsArray)
        
        self.exercisesSetsArray.removeLast()
        
        
        
        if selectedExercises.isEmpty{
            return cell
        }else{
            cell.textLabel!.text = selectedExercises[indexPath.row]
            cell.textLabel!.textColor = UIColor.white
        }
        return cell
        
    }
    
    
    func exercisesAndSetsHandler(){
        
        finalSetsArray = finalSetsArray.suffix(selectedExercises.count)
        
 
        let exerciseArrayAsString: String = selectedExercises.description
        let setsArrayAsString: String = finalSetsArray.description
        
        let newWorkout = Workout(context: self.context)
        newWorkout.name = workoutName
        newWorkout.exerciseNames = exerciseArrayAsString
        newWorkout.amountOfExercises = Int16(selectedExercises.count)
        newWorkout.sets = setsArrayAsString
        newWorkout.created = Date()
        self.saveItems()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedExercises.remove(at: indexPath.row)
            self.updateTheTable()
            
        }
    }
}



//MARK: - TextField delegate
extension NewWorkoutViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
