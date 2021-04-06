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
    
    //declaring varibales needed to record data for user
    //data reeived from previous view controller via segue handler
    var exerciseSetsArray: [(name: String, sets: Int)]!
    var setsArray: [Int]!
    var exerciseNameArray: [String]!
    var workoutName: String!
    var timer: Timer? //set up timer
    var seconds = 0.0

    var weightInput = [String]()
    var exerciseWeights = [String]()
    var finalRepsArray = [(Int)]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //custom cell
    var exerciseReps = ExerciseRepsCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        workoutNameLabel.text! = workoutName
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in   //start the timer
            self.eachSecond()
        }
        
        //sets the weight and reps array to be the size of the sum of sets array
        self.weightInput = [String](repeating: "", count: setsArray.sum())
        self.finalRepsArray = [Int](repeating :0, count: setsArray.sum())

    }
    
    //if the view disappears the timer stops and the navigation button is displayed
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        navigationItem.hidesBackButton = false
    }
    
  
    
    //function to increase seconds and updated display
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    // function to updated the timer every second
    private func updateDisplay() {
        let timeFormatted = FormatDisplay.time(Int(seconds))
        
        self.timerLabel.text = "\(timeFormatted)"
    }
    
    //function for the reps stepper value
    @IBAction func repsStepperValue(_ sender: ValueStepper) {
        
        finalRepsArray[sender.tag] = (Int)(sender.value) //assigns a tag for each stepper value
    
    }
    
    //function to return sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exerciseSetsArray.count
    }
    
    //function to retunr amounts of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     

        return exerciseSetsArray[section].sets

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExerciseRepsCell
        
        cell.exerciseName.text = exerciseSetsArray[indexPath.section].name  //shows the exercise name
        cell.exerciseSets.text = "SET \(indexPath.row + 1)/\(exerciseSetsArray[indexPath.section].sets)"  //returns how many sets are left
        cell.weightTextField.addDoneCancelToolbar(done: (target: self, action: #selector(self.tapDone)), cancel: (target: self, action: #selector(self.tapCancel)))
        cell.repsStepperValue.valueLabel.font = cell.repsStepperValue.valueLabel.font.withSize(22)
        
        
        cell.weightTextField.delegate = self    //makes the text field the delegate
       
        
        var currentCellIndex = 0
        
        //for loop to knon which cell index we are at for each set
        for whichSet in (0 ..< indexPath.section) {
            currentCellIndex += setsArray[whichSet]
        }
        //increment the cell index with the indexPath.row
        currentCellIndex +=  indexPath.row
        cell.weightTextField.tag = currentCellIndex //assign a tag for each text field in the table
        cell.weightTextField.text = weightInput[currentCellIndex] //the text has a respective tag and value in the array
        
        cell.repsStepperValue.tag = currentCellIndex //assign a tag for each text stepper value in the table
        cell.repsStepperValue.value = Double(finalRepsArray[currentCellIndex]) //the value has a respective tag and value in the array
        
        return cell
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
 
        weightInput[textField.tag] = textField.text!   // assign the value to the tag for each text field
        
    }
    

    //text field method
    @objc func tapDone() {
        view.endEditing(true)

    }
    
    //text field method
    @objc func tapCancel(){
        
        view.endEditing(true)
        
    }
    
    //IBAction for the user when they finish their workout
    @IBAction func finishWorkout(_ sender: UIButton) {

    
        //alert to show the user if they want to save or discard their workout
        let alertController = UIAlertController(title: "End Workout?",
                                                    message: "Are you sure you want to stop?",
                                                    preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.saveWorkout()  //saves workout and the respective data
                self.stopWorkout()  //stops timer
                self.tabBarController?.selectedIndex = 2 //sends the user to the log view in the navigation controller
                _ = self.navigationController?.popToRootViewController(animated: false)

            })
            alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
                self.stopWorkout()  //stops timer
                _ = self.navigationController?.popToRootViewController(animated: false) //sends user to the root vierw controller
            })
            
            present(alertController, animated: true)

    }
    
    //function to save the data from the workout
    func saveWorkout() {
        
        //change all of the arrays as a string to save to core data
        let weightArrayAsString: String = weightInput.description
        let repsArrayAsString: String = finalRepsArray.description
        let setsArrayAsString: String = setsArray.description
        let exerciseArrayAsString: String = exerciseNameArray.description
        
        //create an instance of the Workout entitiy and save all the data to core data
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
    
    //function that stops the timer
    func stopWorkout(){
        
        timer?.invalidate()
    }
    
    //function to save data to core data
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
      
    }
    
}



