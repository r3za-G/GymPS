//
//  NewWorkoutViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 23/03/2021.
//

import UIKit

class ExerciseCell: UITableViewCell{
    
    @IBOutlet var setsLabel: UILabel!
    
    @IBAction func stepper(_ sender: UIStepper) {
        setsLabel.text = String(Int(sender.value))
    }
}

class NewWorkoutViewController: UIViewController, SelectedExercisesDelegate, SegueHandlerType, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var setsLabel: UILabel!
    
    
    @IBOutlet var workoutNameTextField: UITextField!
    @IBOutlet var workoutTable: UITableView!

    
    private var exercise = [Exercise]()
    
    var selectedExercises: [String] = []
    
    var delegateExercises: [String] = []
    
    var workoutName: String = ""
    var numberOfSets: String = ""
    
    var exerciseCell = ExerciseCell()
    
    var exercisesAdded = AddExerciseTableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "AddWorkoutTableViewController"
        

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.black
        
    
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
       configureTextfields()

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
        
        self.selectedExercises.append(contentsOf: delegateExercises)
        
        print(selectedExercises)
        self.updateTheTable()
        
    }

    
    @IBAction func workoutName(_ sender: UITextField) {
  
        self.workoutName = workoutNameTextField.text!
 
    }
    
    
    @IBAction func saveWorkout(_ sender: UIButton) {
        
     
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

            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExerciseCell
            
      
            if selectedExercises.isEmpty{
                
                return cell
            }else{
                cell.textLabel!.text = selectedExercises[indexPath.row]
            }
            return cell

    }
}

//MARK: - TextField delegate
extension NewWorkoutViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
