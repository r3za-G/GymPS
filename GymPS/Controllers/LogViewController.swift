//
//  LogViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 31/03/2021.
//

import UIKit
import CoreData

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cardioArray = [Cardio]()    //saved cardio arrays
    var workoutArray = [Workout]()  //saved workout arrays
    
    var indexRowSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "LogViewController"
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //loads the cardio exercise from core data
    func loadCardioExercise() -> [Cardio]?{
        let request: NSFetchRequest<Cardio> = Cardio.fetchRequest()
        do{
            self.cardioArray = try context.fetch(request)
            return cardioArray.reversed()
        }catch {
            print("error fetching data \(error)")
        }
        return cardioArray
    }
    
    //loads the weightlifting workouts from core data
    func loadWorkout() -> [Workout]?{
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        do{
            self.workoutArray = try context.fetch(request)
            return workoutArray.reversed()
        }catch {
            print("error fetching data \(error)")
        }
        return workoutArray
    }
    
    //returns number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    //return titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Cardio Exercises"
        } else {
            return "Weightlifting Exercises"
        }
    }
    
    //returns number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return loadCardioExercise()?.count ?? 0
        } else {
            return loadWorkout()?.count ?? 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0{  //if statement to return cardio exercises in the first section
            let cardioCell = tableView.dequeueReusableCell(withIdentifier: "LogCardioCell", for: indexPath) as? LogCardioTableCell
            let cardioExercise = loadCardioExercise()   //loads cardio Exercise
            
            //returns the cardio exercises in order of data completed
            let cardio = cardioExercise?[indexPath.row]
            cardioCell?.cardio = cardio
            return cardioCell!
            
        } else {
            
            let workoutCell = tableView.dequeueReusableCell(withIdentifier: "LogWorkout", for: indexPath) as? LogWorkoutTableCell
            let workouts = loadWorkout() //loads weightlifting workout
            
            //returns the workout exercises in order of data completed
            let workout = workouts?[indexPath.row]
            workoutCell?.workout = workout
            return workoutCell!
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //shows which index the user selected a row at
        self.indexRowSelected = indexPath.row
        
    }
    
    //fucntion to save the exercises to core data
    func saveExercise(){
        do{
            try context.save()
        } catch{
            print("error saving runs \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //fucntion to allow the user to delete any saved workouts from their log
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                var cardio = loadCardioExercise()
                context.delete((cardio?[indexPath.row])!  ) //deletes cardio from core data
                cardio?.remove(at: indexPath.row) //removes the row at index
                tableView.reloadData()  //reloads the table
                saveExercise()  //saves the exerises
            } else{
                var workout = loadWorkout()
                context.delete((workout?[indexPath.row])!  ) //deletes weightlifting workout from core data
                workout?.remove(at: indexPath.row) //removes the row at index
                tableView.reloadData() //reloads the table
                saveExercise()  //saves the exerises
            }
        }
        
    }
    
}

//MARK: - Segue handler

extension LogViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case detailsOne = "ShowCardioDetails"  //segue to show the cardio details
        case detailsTwo = "ShowWorkoutDetails" //segue to show the workout details
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = tableView.indexPathForSelectedRow
        switch segueIdentifier(for: segue) {
        case .detailsOne:
            let destination = segue.destination as! LogDetailsViewController
            //sends the selected cardio data to LogDetailsViewController
            destination.cardio = cardioArray.reversed()[indexPath!.row]
            
        case .detailsTwo:
            let destination = segue.destination as! LogWorkoutDetailsViewController
            //sends the selected workout data to LogWorkoutDetailsViewController
            destination.workout = workoutArray.reversed()[indexPath!.row]
        }
        
    }
}
