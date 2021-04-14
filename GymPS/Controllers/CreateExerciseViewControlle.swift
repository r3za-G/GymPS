//
//  CreateExerciseViewControlle.swift
//  GymPS
//
//  Created by Reza Gharooni on 11/04/2021.
//


import UIKit

//Delegate protcol method to send the user's created exercise information back to the previous view controller
protocol CreatedExerciseDelegate {
    func didLoadCreatedExercise(createdExercise: [String])
}


class CreateExerciseViewController: UIViewController, UITextFieldDelegate, ToolBarPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    //IB outlets
    @IBOutlet var exerciseNameTextField: UITextField!
    @IBOutlet var exerciseDescriptionTextField: UITextView!
    @IBOutlet var muscleGroupTextField: UITextField!
    
    var addExercise = AddExerciseTableViewController()
    
    //picker-view
    let muscleGroupPickerView = ToolbarPickerView()
    
    let muscleGroups = [ "Abs", "Arms (Biceps)", "Arms (Triceps)", "Back","Chest", "Legs", "Shoulders"]
    
    var exerciseName = ""
    var muscleGroup = ""
    var exericseDescription = ""
    
    var createdExerciseArray = [String]()
    
    //delegate instance
    var delegate: CreatedExerciseDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        configureFields()
        
    }
    //function to set up the text-field and picker views
    func configureFields(){
        
        exerciseNameTextField.delegate = self
        exerciseDescriptionTextField.delegate = self
        
        muscleGroupTextField.delegate = self
        
        muscleGroupTextField.inputView = self.muscleGroupPickerView
        muscleGroupTextField.inputAccessoryView = self.muscleGroupPickerView.toolbar
        
        muscleGroupPickerView.dataSource = self
        muscleGroupPickerView.delegate = self
        muscleGroupPickerView.toolBarDelegate = self
        
        exerciseDescriptionTextField.text = "Give brief exercise description"
        
    }
    
    //allows user to edit text fieldd
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    @IBAction func exerciseName(_ sender: UITextField) {
        //set the user's exercise name
        self.exerciseName = exerciseNameTextField.text!
    }
    
    //protocol method for the picker view
    func doneButtonTapped() {
        let row = self.muscleGroupPickerView.selectedRow(inComponent: 0)
        self.muscleGroupPickerView.selectRow(row, inComponent: 0, animated: false)
        self.muscleGroupTextField.text = self.muscleGroups[row]
        
        //sets the exerices muscle group
        self.muscleGroup = self.muscleGroupTextField.text!
        
        self.muscleGroupTextField.resignFirstResponder()
    }
    
    //protocol method for the picker view
    func cancelButtonTapped() {
        self.muscleGroupTextField.text = ""
        self.muscleGroupTextField.resignFirstResponder()
    }
    
    
    //function to return components of the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //returns the number of rows in pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muscleGroups.count
    }
    
    //assigns each row using the muscleGroups array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return muscleGroups[row]
    }
    
    //function to show the selected row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let chosenMuscleGroup = self.muscleGroups[row]
        self.muscleGroupTextField.text = chosenMuscleGroup
        
    }
    
    //function to send the information back to previous view controller
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        self.exericseDescription = exerciseDescriptionTextField.text!
        print(exericseDescription)
        
        //set up alerts to see make sure the user adds all the necessary information for their created exercise
        if exerciseName == ""{
            
            let alert = UIAlertController(title: "Add Exercise Name", message: "Please type a name for your exercise.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if muscleGroup == ""{
            let alert = UIAlertController(title: "Pick Muscle group", message: "Please pick the muscle group your exercises belongs to.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if exericseDescription == ""{
            let alert = UIAlertController(title: "Add Exercise Description", message: "Please add a brief description of your exercise.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            //array containing the created exercise data
            self.createdExerciseArray.append(contentsOf: [exerciseName,  muscleGroup,  exericseDescription])
            
            //call the delegate method to send the data back
            self.delegate?.didLoadCreatedExercise(createdExercise: createdExerciseArray)
            
            //navigate to previous view controller
            self.navigationController?.popViewController(animated: false)
            
        }
        
    }
}
