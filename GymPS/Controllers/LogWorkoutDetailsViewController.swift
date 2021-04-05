//
//  LogWorkoutDetailsViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 31/03/2021.
//

import UIKit

class LogWorkoutDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
    var workoutArray = [Workout]()
    var workout: Workout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        let exerciseNamesStringAsData = workout.exerciseNames!.data(using: String.Encoding.utf16)
        self.exerciseNames = try! JSONDecoder().decode([String].self, from: exerciseNamesStringAsData!)
        
        let setsStringAsData = workout.sets!.data(using: String.Encoding.utf16)
        self.setsArray = try! JSONDecoder().decode([Int].self, from: setsStringAsData!)
        
        let repsStringAsData = workout.reps!.data(using: String.Encoding.utf16)
        self.repsArray = try! JSONDecoder().decode([Int].self, from: repsStringAsData!)
        
        let weightStringAsData = workout.weight!.data(using: String.Encoding.utf16)
        self.weightArray = try! JSONDecoder().decode([String].self, from: weightStringAsData!)
        
        for i in zip(exerciseNames, setsArray){
            self.exerciseArray.append((name: i.0, sets: i.1))
        }
        
        
        
       
        
        let workoutNameString = workout.workoutName!
        let formattedDate = FormatDisplay.date(workout.dateCompleted)
        let formattedTime = FormatDisplay.time(Int(workout.duration))
        let totalExercisesInt = exerciseArray.count
        
     
        
        if !(weightArray.contains("")) {
        weightArrayAsDouble = weightArray.map { Double($0)!}
        }
        
        
        workoutName.text = "\(workoutNameString)"
        dateCompleted.text = "\(formattedDate)"
        duration.text = "\(formattedTime)"
        
        if totalExercisesInt == 1 {
            totalExercise.text = "\(totalExercisesInt) Exercise"
        } else {
            totalExercise.text = "\(totalExercisesInt) Exercises"
        }
        
        self.totalWeight = zip(repsArray, weightArrayAsDouble).map { Double($0) * $1 }
        
        totalSets.text = "\(setsArray.sum()) Sets"
        totalReps.text = "\(repsArray.sum()) Reps"
        totalWeightLifted.text = "\(totalWeight.sum())kg Weight Lifted "
        
        print("-------------------")
        
        
        print("sets: \(setsArray)")
        print("reps: \(repsArray)")
        print("weights: \(weightArrayAsDouble)")
         
        for i in zip(repsArray, weightArrayAsDouble){
            self.repsWeightsArray.append((reps: i.0, weight: i.1))
        }
        
 
        
//        print(exerciseArray)
//        print("-------------------")
//        print(repsWeightsArray)
        print("-------------------")

//
//        self.groupedRepsWeightArray = Array(repeating: Array(repeating: Array(repeating: 0, count: 2), count: setsArray.index(after: 0)), count: exerciseArray.count)
//        print(groupedRepsWeightArray)
        
        for n in setsArray {
            self.groupedRepsWeightArray = repsWeightsArray.chunked(by: n)
            print(groupedRepsWeightArray)
        }
       
       
        

        
//        groupedRepsWeightArray = repsWeightsArray.joined(separator: ",")
            
    

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray[section].sets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutDetailsCell", for: indexPath) as! WorkoutDetailsCell
        cell.exerciseName.text = exerciseArray[indexPath.section].name
        cell.setsLabel.text = "SET \(indexPath.row + 1)/\(exerciseArray[indexPath.section].sets)"
//        cell.weightsAndRepsLabel.text = "\(repsWeightsArray[indexPath.row].reps) x \(repsWeightsArray[indexPath.row].weight) kg"
    
        return cell
        
    }
    

}

extension Array {
    
    func chunked(by distance: Int) -> [[Element]] {
        let indicesSequence = stride(from: startIndex, to: endIndex, by: distance)
        let array: [[Element]] = indicesSequence.map {
            let newIndex = $0.advanced(by: distance) > endIndex ? endIndex : $0.advanced(by: distance)
            //let newIndex = self.index($0, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex // also works
            return Array(self[$0 ..< newIndex])
        }
        return array
    }
    
}
