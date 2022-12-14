//
//  LogWorkoutDetailsViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 31/03/2021.
//

import UIKit

class LogWorkoutDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //All of the UI labels to display the workout info for selected workout
    @IBOutlet var workoutName: UILabel!
    @IBOutlet var dateCompleted: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var totalExercise: UILabel!
    @IBOutlet var totalSets: UILabel!
    @IBOutlet var totalReps: UILabel!
    @IBOutlet var totalWeightLifted: UILabel!
    
    var exerciseNames = [String]()
    var setsArray = [Int]()
    var repsArray = [Int]()
    var weightArray = [String]()
    var weightArrayAsDouble = [Double]()
    var exerciseArray = [(name: String, sets: Int)]()
    var repsWeightsArray = [(reps: Int, weight: Double)]()
    var totalWeight = [Double]()
    var groupedRepsWeightArray = [[(reps: Int, weight: Double)]]()

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var workoutArray = [Workout]() //declared workout array for loaded workouts
    var workout: Workout!   //workout data received from segue

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        /*
         decoded all of the array as strings from core data so they are turned back into arrays of their respected data types.
         */
        let exerciseNamesStringAsData = workout.exerciseNames?.data(using: String.Encoding.utf16)
        self.exerciseNames = try! JSONDecoder().decode([String].self, from: exerciseNamesStringAsData!)
        
        let setsStringAsData = workout.sets?.data(using: String.Encoding.utf16)
        self.setsArray = try! JSONDecoder().decode([Int].self, from: setsStringAsData!)
        
        let repsStringAsData = workout.reps?.data(using: String.Encoding.utf16)
        self.repsArray = try! JSONDecoder().decode([Int].self, from: repsStringAsData!)
        
        let weightStringAsData = workout.weight?.data(using: String.Encoding.utf16)
        self.weightArray = try! JSONDecoder().decode([String].self, from: weightStringAsData!)
        
        
        //use zip function to append two arrays into one
        for i in zip(exerciseNames, setsArray){
            self.exerciseArray.append((name: i.0, sets: i.1))
        }
        
        
        let workoutNameString = workout.workoutName!
        let dateFormatted = DisplayFormatter.date(workout.dateCompleted)
        let timeFormatted = DisplayFormatter.time(Int(workout.duration))
        let totalExercisesInt = exerciseArray.count
        
        //turn the weightArray into a double array to work out the total weight lifted
        if !(weightArray.contains("")) {
        weightArrayAsDouble = weightArray.map { Double($0)!}
        }
        
        //display the workout name, time and date
        workoutName.text = "\(workoutNameString)"
        dateCompleted.text = "\(dateFormatted)"
        duration.text = "\(timeFormatted)"
        
        //if statement to show singular/plural exercises if their is only one exercise executed
        if totalExercisesInt == 1 {
            totalExercise.text = "\(totalExercisesInt) Exercise"
        } else {
            totalExercise.text = "\(totalExercisesInt) Exercises"
        }
        
        //zip function to work out the amount of weight lifted
        self.totalWeight = zip(repsArray, weightArrayAsDouble).map { Double($0) * $1 }
        
        //totals sets, reps and weight lifted labels
        totalSets.text = "\(setsArray.sum()) Sets"
        totalReps.text = "\(repsArray.sum()) Reps"
        totalWeightLifted.text = "\(totalWeight.sum())kg Weight Lifted "
        
        //use the zip function to append together the reps and weight lifted for each set
        for i in zip(repsArray, weightArrayAsDouble){
            self.repsWeightsArray.append((reps: i.0, weight: i.1))
        }
        
        // variable to find the current index in the array
        var currentIndex = 0

        // for loop to iterate over the sets array make groupedRepsWeightArray of the correct size
        for (index, values) in setsArray.enumerated(){
            
            self.groupedRepsWeightArray.append([repsWeightsArray[currentIndex]])
            currentIndex += 1
            //second for loop to append the correct values at the correct index
            for _ in 1..<values {
                self.groupedRepsWeightArray[index].append(repsWeightsArray[currentIndex])
                currentIndex += 1
            }
        }
        

    }
    
    //number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exerciseArray.count
    }
    
    //number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray[section].sets
    }
    
    //cells to display the exercise and set information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutDetailsCell", for: indexPath) as! WorkoutDetailsCell
        cell.exerciseName.text = exerciseArray[indexPath.section].name  //workout names
        cell.setsLabel.text = "SET \(indexPath.row + 1)/\(exerciseArray[indexPath.section].sets)"  //what sets the user did
        cell.weightsAndRepsLabel.text = "\(groupedRepsWeightArray[indexPath.section][indexPath.row].reps) x \(groupedRepsWeightArray[indexPath.section][indexPath.row].weight) kg"  //The amount of reps and weight for each exercise
    
        return cell
        
    }

}

