//
//  CreateExerciseViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 26/03/2021.
//

import UIKit

protocol CreatedExerciseDelegate {
    func didLoadCreatedExercise(createdExercise: [String])
}


class CreateExerciseViewController: UIViewController, UITextFieldDelegate, ToolbarPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    @IBOutlet var exerciseNameTextField: UITextField!
    @IBOutlet var exerciseDescriptionTextField: UITextView!
    @IBOutlet var muscleGroupTextField: UITextField!
    
    let muscleGroupPickerView = ToolbarPickerView()
    
    let muscleGroups = ["Chest", "Arms (Biceps)", "Arms (Triceps)", "Back", "Legs", "Shoulders", "Abs"]
    
    var exerciseName = ""
    var muscleGroup = ""
    var exericseDescription = ""
    
    var createdExerciseArray = [String]()
    
    var delegate: CreatedExerciseDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFields()

    }
    
    func configureFields(){
        
        exerciseNameTextField.delegate = self
        exerciseDescriptionTextField.delegate = self
        
        muscleGroupTextField.delegate = self
        
        muscleGroupTextField.inputView = self.muscleGroupPickerView
        muscleGroupTextField.inputAccessoryView = self.muscleGroupPickerView.toolbar
        
        muscleGroupPickerView.dataSource = self
        muscleGroupPickerView.delegate = self
        muscleGroupPickerView.toolbarDelegate = self

    }
    
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
        
        self.exerciseName = exerciseNameTextField.text!
    }
    


    func didTapDone() {
        
        let row = self.muscleGroupPickerView.selectedRow(inComponent: 0)
        self.muscleGroupPickerView.selectRow(row, inComponent: 0, animated: false)
        self.muscleGroupTextField.text = self.muscleGroups[row]
        
        self.muscleGroup = self.muscleGroupTextField.text!
        
        self.muscleGroupTextField.resignFirstResponder()
    }
    
    func didTapCancel() {
        
        self.muscleGroupTextField.text = nil
        self.muscleGroupTextField.resignFirstResponder()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muscleGroups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return muscleGroups[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let chosenMuscleGroup = self.muscleGroups[row]
        self.muscleGroupTextField.text = chosenMuscleGroup
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        self.exericseDescription = exerciseDescriptionTextField.text!
        
        if exerciseName == ""{
            
            let alert = UIAlertController(title: "Add Exercise Name", message: "Please type a name for your exercise.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else if muscleGroup == ""{
            let alert = UIAlertController(title: "Pick Muscle group", message: "Please pick the muscle group your exercises belongs to.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        } else if description == ""{
            let alert = UIAlertController(title: "Pick Add Description", message: "Please add a brief description of your exercise.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
        

        self.createdExerciseArray.append(contentsOf: [exerciseName, muscleGroup, exericseDescription])
        
        self.delegate?.didLoadCreatedExercise(createdExercise: createdExerciseArray)
        self.navigationController?.popViewController(animated: false)
        
    }
    
}
