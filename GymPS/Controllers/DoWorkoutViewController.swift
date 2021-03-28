//
//  DoWorkoutViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 28/03/2021.
//

import UIKit

class DoWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    var exerciseSetsArray: [(name: String, sets: Int)]!
    var setsArray: [Int]!
    var workoutName: String!
    var timer: Timer?
    var seconds = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        print(exerciseSetsArray!)
        
        workoutNameLabel.text! = workoutName
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
            
        }
        
        print(setsArray!)
        

        // Do any additional setup after loading the view.
    }
    
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    
    private func updateDisplay() {
        let formattedTime = FormatDisplay.time(Int(seconds))
        
        self.timerLabel.text = "\(formattedTime)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exerciseSetsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
//        for sets in exerciseSetsArray{
//            sets.sets.value
//        }
        return exerciseSetsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisesCell", for: indexPath)
        
        cell.textLabel!.text = exerciseSetsArray[indexPath.row].name
        return cell
    }


}
