//
//  ExerciseDescriptionViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 23/03/2021.
//

import Foundation
import UIKit

class ExerciseDescriptionViewController: UIViewController{

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = exerciseDescription
        textView.allowsEditingTextAttributes = false
    }
    
}
