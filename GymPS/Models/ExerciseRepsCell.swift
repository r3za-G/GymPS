//
//  ExerciseRepsCell.swift
//  GymPS
//
//  Created by Reza Gharooni on 29/03/2021.
//

import Foundation
import UIKit
import ValueStepper

//custome cell for tjhe exercises
class ExerciseRepsCell: UITableViewCell {
    
    //different labels, text fields and value stepper which the cell contains
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseSets: UILabel!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var repsStepperValue: ValueStepper!
    
}

//extension so that the text field displays a done and cancel button
extension UITextField {
    
    func addDoneCancelToolbar(done: (target: Any, action: Selector)? = nil, cancel: (target: Any, action: Selector)? = nil) {
        let cancel = cancel ?? (target: self, action: #selector(cancelButtonTapped))
        let done = done ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: cancel.target, action: cancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: done.target, action: done.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // fucntions for the text field
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
    }
    @objc func cancelButtonTapped() {
        self.resignFirstResponder()
        
    }
}


