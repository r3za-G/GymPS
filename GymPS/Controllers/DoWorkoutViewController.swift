//
//  DoWorkoutViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 28/03/2021.
//

import UIKit
import ValueStepper

class DoWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var exerciseSetsArray: [(name: String, sets: Int)]!
    var setsArray: [Int]!
    var workoutName: String!
    var timer: Timer?
    var seconds = 0.0
    
    var weightInput = [String]()
    var exerciseWeights = [String]()
    var finalRepsArray = [(Int)]()
    
    var exerciseReps = ExerciseRepsCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        workoutNameLabel.text! = workoutName
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
            
        }
    }
    
  
    
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    
    private func updateDisplay() {
        let formattedTime = FormatDisplay.time(Int(seconds))
        
        self.timerLabel.text = "\(formattedTime)"
    }
    
    
    @IBAction func repsStepperValue(_ sender: ValueStepper) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exerciseSetsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     

        return exerciseSetsArray[section].sets

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExerciseRepsCell
        
        cell.exerciseName.text = exerciseSetsArray[indexPath.section].name
        cell.exerciseSets.text = "SET \(indexPath.row + 1)/\(exerciseSetsArray[indexPath.section].sets)"
        
        cell.weightTextField.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.tapDone)), onCancel: (target: self, action: #selector(self.tapCancel)))
        cell.repsStepperValue.valueLabel.font = cell.repsStepperValue.valueLabel.font.withSize(22)
        
        cell.weightTextField.delegate = self
        
        
        
        self.weightInput.removeAll()
        self.weightInput.append(cell.weightTextField.text!)
        self.exerciseWeights.append(contentsOf: self.weightInput)
        
        
//        self.exercisesRepsArray.append((Int)(cell.repsStepperValue.value))
//        self.finalRepsArray.append(contentsOf: self.exercisesRepsArray)
//        self.exercisesRepsArray.removeLast()



//        print(weightInput)
//        print(exerciseWeights)
        
    
        return cell
    }
    
    
    @IBAction func userWeightInput(_ sender: UITextField) {
        
        weightInput.append(sender.text!)
        print(sender.text!)
    }
    
    
    @objc func tapDone() {
        view.endEditing(true)
//        tableView.reloadData()
    }
    
    @objc func tapCancel() {
        view.endEditing(true)
//        tableView.reloadData()
    }
    
    
    @IBAction func finishWorkout(_ sender: UIButton) {
        
//        self.exerciseWeights = exerciseWeights.suffix(exerciseSetsArray.count)
//        self.finalRepsArray = finalRepsArray.suffix(exerciseSetsArray.count)
        
//        print(exerciseWeights)
//        print(finalRepsArray)
        print(weightInput)
//        print(exerciseWeights)
    }
    
}



