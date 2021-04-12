//
//  NewWorkoutViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 23/03/2021.
//

import Foundation
import UIKit
import CoreData
import ValueStepper //import from a cocoapod


//class for the custom exericse cell
class ExerciseCell: UITableViewCell{
    
    //values for the sets stepper
    @IBOutlet weak var setsStepper: ValueStepper!
    
    
    @IBAction func setsValueChanged(_ sender: ValueStepper) {

    }

}

class NewWorkoutViewController: UIViewController, SelectedExercisesDelegate, SegueHandlerType, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var workoutNameTextField: UITextField!
    @IBOutlet var workoutTable: UITableView!
    

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
        workoutNameTextField.font = UIFont.systemFont(ofSize: 20.0)
           
    }
    
    private func configureTextfields(){
        workoutNameTextField.delegate = self    //comfigures the text field
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
            exercisesSelector.delegate = self   //sets the delegate as self, so it receives the selected exercises from AddExerciseTableViewController
        }
    }
    
    //IBAction to send user to AddExerciseTableViewController when they press the "Add Exercises" button
    @IBAction func addExercisesPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AddSelectedExercises", sender: nil)
    }
    
    //delegate function that receieves the selected exercises from AddExerciseTableViewController
    func didLoadSelectedExercises(exercises: [String]) {
        //sets the exercises as delegateExercises
        self.delegateExercises = exercises
        
        self.updateTheTable()
        
        updatedExercisesArray()
        
    }
    
    //reloads the data in the table
    func updateTheTable() {
        workoutTable.reloadData()
    }
    
    //function to only add exercises the user hasn't already selecteds
    func updatedExercisesArray() {
        
        for exercises in delegateExercises{ //iterates over the arrray to append non duplicate exercises
            if !(selectedExercises.contains(exercises)){
                self.selectedExercises.append(exercises)
            }
        }
        self.updateTheTable()
    }
    
    //IBAction for the user to input a name for their workout
    @IBAction func workoutName(_ sender: UITextField) {
        
        self.workoutName = workoutNameTextField.text!
        
    }
    
    //function to save the workout data
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
        updateTheTable()
    }
    
    //IBAction so the user can save the workout data
    @IBAction func saveWorkout(_ sender: UIButton) {

        exercisesAndSetsHandler()   //calls the function to save the workout data
        self.navigationController?.popViewController(animated: false) //when the data is saved the user is returned to WorkoutTableViewController where they can view their saved workouts
        
    }
    
    
    @IBAction func setsValueChangedVC(_ sender: ValueStepper) {
        self.updateTheTable()
    }
    
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the amount of selected exericses
        if selectedExercises.count == 0{
            return 0
        } else {
            return selectedExercises.count
            
        }
    }
    
    
    //fucntion to show the title for the section
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
        
        //exercise sets array appends the value for each sets stepper
        self.exercisesSetsArray.append((Int)(cell.setsStepper.value))
        self.finalSetsArray.append(contentsOf: self.exercisesSetsArray)
        self.exercisesSetsArray.removeLast()
        
        if selectedExercises.isEmpty{
            return cell
        }else{
            cell.textLabel!.text = selectedExercises[indexPath.row] //returns exercise names
            cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.textLabel!.textColor = UIColor.white
        }
        return cell
        
    }
    
    
    
    
    
    func exercisesAndSetsHandler(){
        
        self.finalSetsArray = finalSetsArray.suffix(selectedExercises.count)    //keeps the final selectedExercises.count amount of sets in the array
        
        let exerciseArrayAsString: String = selectedExercises.description   //change the array to a string to save to core data
        let setsArrayAsString: String = finalSetsArray.description          //change the array to a string to save to core data
        
  
        //if statements to show alerts to the user if they haven't added a name to their workout, added sets for each exercise or even added any exrecise
        //if all statements are satisfied, the user can save the workout data to core data
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
            //save the workout data to core data
            let newWorkout = CreateWorkout(context: self.context)
            newWorkout.name = workoutName
            newWorkout.exerciseNames = exerciseArrayAsString
            newWorkout.amountOfExercises = Int16(selectedExercises.count)
            newWorkout.sets = setsArrayAsString
            newWorkout.created = Date()
            self.saveItems()
        }
        
        
    }
    
    //function to allow the user to delete any exercises they don't wish to add to their workout
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
