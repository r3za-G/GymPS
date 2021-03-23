//
//  AddExerciseCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 19/03/2021.
//

import Foundation
import UIKit

class AddExerciseCell: UITableViewCell,  UITextFieldDelegate, ToolbarPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    let muscleGroup = ToolbarPickerView()
    let muscleGroups = ["Chest", "Arms (Biceps)", "Arms (Triceps)", "Back", "Legs", "Shoulders", "Abs"]
    var muscleGroupSelected = ""
    
    
    @IBAction func addExercise(_ sender: Any) {
    }
    
    
    func didTapDone() {
        
    }
    
    func didTapCancel() {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muscleGroups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.muscleGroups[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        muscleGroupSelected = self.muscleGroups[row]
    }
    
 
}
