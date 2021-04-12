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
    
    @IBOutlet weak var tableViewOne: UITableView!
    
    @IBOutlet weak var tableViewTwo: UITableView!
    
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
    var cellIdentifier = ""
    var previousExerciseNames = [String]()
    var previousSetsArray = [Int]()
    var previousRepsArray = [Int]()
    var previousWeightArray = [String]()
    var weightArrayAsDouble = [Double]()
    var previousExerciseArray =  [(name: String, sets: Int)]()
    var repsWeightsArray = [(reps: Int, weight: Double)]()
    var groupedRepsWeightArray = [[(reps: Int, weight: Double)]]()
    
    var loadWorkout = [Workout]()
    var workout: Workout!
    
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
        self.weightInput = [String](repeating: "0", count: setsArray.sum())
        self.finalRepsArray = [Int](repeating :0, count: setsArray.sum())
        
        self.loadWorkout = loadWorkouts()!
        if loadWorkouts()?.isEmpty == false{
            for x in loadWorkout{
                if workoutName == x.workoutName{
                    self.workout = x
                }
            }
            /*
             decoded all of the array as strings from core data so they are turned back into arrays of their respected data types.
             */
            let exerciseNamesStringAsData = workout.exerciseNames?.data(using: String.Encoding.utf16)
            self.previousExerciseNames = try! JSONDecoder().decode([String].self, from: exerciseNamesStringAsData!)
            
            let setsStringAsData = workout.sets?.data(using: String.Encoding.utf16)
            self.previousSetsArray = try! JSONDecoder().decode([Int].self, from: setsStringAsData!)
            
            let repsStringAsData = workout.reps?.data(using: String.Encoding.utf16)
            self.previousRepsArray = try! JSONDecoder().decode([Int].self, from: repsStringAsData!)
            
            let weightStringAsData = workout.weight?.data(using: String.Encoding.utf16)
            self.previousWeightArray = try! JSONDecoder().decode([String].self, from: weightStringAsData!)
        }
        
        
        
        
        //use zip function to append two arrays into one
        for i in zip(previousExerciseNames, previousSetsArray){
            self.previousExerciseArray.append((name: i.0, sets: i.1))
        }
        
        //turn the weightArray into a double array to work out the total weight lifted
        if !(previousWeightArray.contains("")) {
            weightArrayAsDouble = previousWeightArray.map { Double($0)!}
        }
        
        //use the zip function to append together the reps and weight lifted for each set
        for i in zip(previousRepsArray, weightArrayAsDouble){
            self.repsWeightsArray.append((reps: i.0, weight: i.1))
        }
        
        // variable to find the current index in the array
        var currentIndex = 0
        
        // for loop to iterate over the sets array make groupedRepsWeightArray of the correct size
        for (index, values) in previousSetsArray.enumerated(){
            self.groupedRepsWeightArray.append([repsWeightsArray[currentIndex]])
            currentIndex += 1
            //second for loop to append the correct values at the correct index
            for _ in 1..<values {
                self.groupedRepsWeightArray[index].append(repsWeightsArray[currentIndex])
                currentIndex += 1
            }
        }
        print(groupedRepsWeightArray)
        
        
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
    
    
    func loadWorkouts() -> [Workout]?{
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        do{
            self.loadWorkout = try context.fetch(request)
            return loadWorkout
        }catch {
            print("error fetching data \(error)")
        }
        return loadWorkout
    }
    
    //function to return sections
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewOne{
            return exerciseSetsArray.count
        } else {
            if loadWorkouts()?.isEmpty == false{
                return exerciseSetsArray.count
            } else {
                return 1
            }
        }
    }
    
    //function to return amounts of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewOne{
            return exerciseSetsArray[section].sets
        } else {
            if loadWorkouts()?.isEmpty == false{
                return exerciseSetsArray[section].sets
            } else{
                return 1
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewOne{
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath) as! ExerciseRepsCell)
            
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
        
        else {
            // If statement to see if there are any previoius workouts
            if loadWorkouts()?.isEmpty == false{
                //Shows the last workout the user did so they can compare their reps and weight
                let cell = tableView.dequeueReusableCell(withIdentifier: "previousWorkoutDetailsCell", for: indexPath) as! PreviousWorkoutDetails
                cell.exerciseName.text = previousExerciseArray[indexPath.section].name  //workout names
                cell.setsLabel.text = "SET \(indexPath.row + 1)/\(previousExerciseArray[indexPath.section].sets)"  //what sets the user did
                cell.weightsAndRepsLabel.text = "\(groupedRepsWeightArray[indexPath.section][indexPath.row].reps) x \(groupedRepsWeightArray[indexPath.section][indexPath.row].weight) kg"  //The amount of reps and weight for each exercise
                return cell
            } else {
                //if there are no pervious workouts the cell will print "No previous workout data"
                let cell = tableView.dequeueReusableCell(withIdentifier: "previousWorkoutDetailsCell", for: indexPath) as! PreviousWorkoutDetails
                cell.exerciseName.text = ""
                cell.setsLabel.text = ""
                cell.weightsAndRepsLabel.text = ""
                cell.textLabel?.text = "No previous workout data"
                cell.textLabel?.textColor = UIColor.white
                return cell
            }
            
        }
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
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
        })
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



