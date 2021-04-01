//
//  DoWorkoutViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 28/03/2021.
//

import UIKit
import ValueStepper
import CoreData

class DoWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var exerciseSetsArray: [(name: String, sets: Int)]!
    var setsArray: [Int]!
    var exerciseNameArray: [String]!
    var workoutName: String!
    var timer: Timer?
    var seconds = 0.0

    var weightInput = [String]()
    var exerciseWeights = [String]()
    var finalRepsArray = [(Int)]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    var exerciseReps = ExerciseRepsCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        workoutNameLabel.text! = workoutName
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        
        self.weightInput = [String](repeating: "", count: setsArray.sum())
        self.finalRepsArray = [Int](repeating :0, count: setsArray.sum())

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        navigationItem.hidesBackButton = false
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
        
        finalRepsArray[sender.tag] = (Int)(sender.value)

       
        
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
       
        
        var currentCellIndex = 0
        
        for whichSet in (0 ..< indexPath.section) {
            currentCellIndex += setsArray[whichSet]
        }
        
        currentCellIndex +=  indexPath.row
        cell.weightTextField.tag = currentCellIndex
        cell.weightTextField.text = weightInput[currentCellIndex]
        
        cell.repsStepperValue.tag = currentCellIndex
        cell.repsStepperValue.value = Double(finalRepsArray[currentCellIndex])
        
        return cell
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
 
        weightInput[textField.tag] = textField.text!
        
    }
    

    
    @objc func tapDone() {
        view.endEditing(true)

    }
    
    @objc func tapCancel(){
        
        view.endEditing(true)
        
    }
    
    
    @IBAction func finishWorkout(_ sender: UIButton) {

        print(weightInput)
        print(finalRepsArray)
        print(timerLabel.text!)
        
        let alertController = UIAlertController(title: "End Workout?",
                                                    message: "Are you sure you want to stop?",
                                                    preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.saveWorkout()
                self.stopWorkout()
                self.performSegue(withIdentifier: .details, sender: nil)
            })
            alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
                self.stopWorkout()
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            
            present(alertController, animated: true)

    }
    
    func saveWorkout() {
        
        let weightArrayAsString: String = weightInput.description
        let repsArrayAsString: String = finalRepsArray.description
        let setsArrayAsString: String = setsArray.description
        let exerciseArrayAsString: String = exerciseNameArray.description
        
        let workout = Workout(context: self.context)
        workout.reps = repsArrayAsString
        workout.weight = weightArrayAsString
        workout.duration = Int16(seconds)
        workout.workoutName = workoutName
        workout.dateCompleted = Date()
        workout.sets = setsArrayAsString
        workout.exerciseNames = exerciseArrayAsString
        saveItems()
        
    }
    
    func stopWorkout(){
        
        timer?.invalidate()
    }
    
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
      
    }
    
}


extension DoWorkoutViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "ToLogView"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details: break
            
//            let destination = segue.destination as! CardioDetailsViewController
//            destination.cardio = cardio
        }
    }
}

