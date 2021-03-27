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
    var exercisesSetsArray = [(Int)]()
    var finalSetsArray = [(Int)]()
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
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
        
        self.workoutTable.isEditing = true
        
        
        
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
        

        cell.setsLabel.text = String(Int(cell.setsStepper.value))
       
        
        self.exercisesSetsArray.append((Int)(cell.setsStepper.value))
        self.finalSetsArray.append(contentsOf: self.exercisesSetsArray)
        self.exercisesSetsArray.removeLast()

        if selectedExercises.isEmpty{
            return cell
        }else{
            cell.textLabel!.text = selectedExercises[indexPath.row]
            cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
            cell.textLabel!.textColor = UIColor.white
        }
        return cell
        
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
        
        let exericeToMove = selectedExercises[sourceIndexPath.row]
        
        selectedExercises.remove(at: sourceIndexPath.row)
        selectedExercises.insert(exericeToMove, at: destinationIndexPath.row)
        
    }
    
    
    
    func exercisesAndSetsHandler(){
        
        self.finalSetsArray = finalSetsArray.suffix(selectedExercises.count)

        let exerciseArrayAsString: String = selectedExercises.description
        let setsArrayAsString: String = finalSetsArray.description
        

        if selectedExercises.isEmpty == true {
            
            let alert = UIAlertController(title: "Add Exercises", message: "Please add desired exercises to your workout.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if workoutName == "" {
            
            let alert = UIAlertController(title: "Add Workout Name", message: "Please choose a name for your workout.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if finalSetsArray.contains(0){
            
            let alert = UIAlertController(title: "Choose Sets", message: "Please pick how many sets you wish to do for each exercise.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let newWorkout = Workout(context: self.context)
            newWorkout.name = workoutName
            newWorkout.exerciseNames = exerciseArrayAsString
            newWorkout.amountOfExercises = Int16(selectedExercises.count)
            newWorkout.sets = setsArrayAsString
            newWorkout.created = Date()
            self.saveItems()
        }
        
       
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
