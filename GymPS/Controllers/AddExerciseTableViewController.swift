//
//  AddExerciseTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit
import CoreData

//protocol delegate method to send the user's selected exercises back to the previous view controller (NewWorkoutViewController)
protocol SelectedExercisesDelegate {
    func didLoadSelectedExercises(exercises: [String])
}

var exerciseDescription = ""

class AddExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExerciseManagerDelegate, UITextFieldDelegate, SegueHandlerType {
    
    
    @IBOutlet var exerciseTable: UITableView!
    
    var exerciseManager = ExerciseManager()
    var delegate: SelectedExercisesDelegate? // variable delegate
    var exerciseInfo: ExerciseData? = nil
    
    //arrays for each specific muscle group
    var chestExercises: [(name: String, muscleGroup: String, description: String)] = []
    var bicepExercises: [(name: String, muscleGroup: String, description: String)] = []
    var tricepExercises: [(name: String, muscleGroup: String, description: String)] = []
    var backExercises: [(name: String, muscleGroup: String, description: String)] = []
    var legsExercises: [(name: String, muscleGroup: String, description: String)] = []
    var shouldersExercises: [(name: String, muscleGroup: String, description: String)] = []
    var absExercises: [(name: String, muscleGroup: String, description: String)] = []
    var exercisesSelected: [String] = []
    var exerciseArray = [[(name: String, muscleGroup: String, description: String)]]()
    
    

   // datastack context to save/load data to/from core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "AddExerciseTableViewController"
        
      
        exerciseManager.delegate = self //delegate to retrieve exercise info from the ExerciseManager
        exerciseManager.fetchExercises()//fetches the exercise data
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
 
    
   
    //function to reload data in the tableview
    func updateTheTable() {
        exerciseTable.reloadData()
    }
    
    //Delegate protocol function from ExerciseManager. This is where the exercise data called from the API is received and manipiulated so the user can view it.
    func didLoadExercise(_ exerciseManager: ExerciseManager, exercise: ExerciseData)  {
        
        self.exerciseInfo = exercise
        
        if exerciseInfo?.Exercises != nil{
            for n in 0..<(exerciseInfo!.Exercises.count){   //for loop to iterate over the exercise info array
                                                            //append each respected muscle groups to their own array
                if exerciseInfo!.Exercises[n].muscleGroup == "Chest"{
                    self.chestExercises.append((name: exerciseInfo!.Exercises[n].name,
                                                muscleGroup: exerciseInfo!.Exercises[n].muscleGroup,
                                                description: exerciseInfo!.Exercises[n].description))
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Arms (Biceps)"{
                    self.bicepExercises.append((name: exerciseInfo!.Exercises[n].name,
                                                muscleGroup: exerciseInfo!.Exercises[n].muscleGroup,
                                                description: exerciseInfo!.Exercises[n].description))

                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Arms (Triceps)" {
                    self.tricepExercises.append((name: exerciseInfo!.Exercises[n].name,
                                                 muscleGroup: exerciseInfo!.Exercises[n].muscleGroup,
                                                 description: exerciseInfo!.Exercises[n].description))

                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Back" {
                    self.backExercises.append((name: exerciseInfo!.Exercises[n].name,
                                               muscleGroup: exerciseInfo!.Exercises[n].muscleGroup,
                                               description: exerciseInfo!.Exercises[n].description))
          
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Legs" {
                    self.legsExercises.append((name: exerciseInfo!.Exercises[n].name,
                                               muscleGroup: exerciseInfo!.Exercises[n].muscleGroup,
                                               description: exerciseInfo!.Exercises[n].description))
                   
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Shoulders" {
                    self.shouldersExercises.append((name: exerciseInfo!.Exercises[n].name,
                                                    muscleGroup: exerciseInfo!.Exercises[n].muscleGroup,
                                                    description: exerciseInfo!.Exercises[n].description))
     
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Abs" {
                    self.absExercises.append((name: exerciseInfo!.Exercises[n].name,
                                              muscleGroup: exerciseInfo!.Exercises[n].muscleGroup,
                                              description: exerciseInfo!.Exercises[n].description))
                    
                }
            }
            
        }
        
        
    
        // sorts all the muscle group arrays so they are in alphabetical order
        let sortedChestArray = self.chestExercises.sorted{ $0.name < $1.name }
        let sortedBicepArray = self.bicepExercises.sorted{ $0.name < $1.name }
        let sortedTricepArray = self.tricepExercises.sorted{ $0.name < $1.name }
        let sortedBackArray = self.backExercises.sorted{ $0.name < $1.name }
        let sortedLegsArray = self.legsExercises.sorted{ $0.name < $1.name }
        let sortedShouldersArray = self.shouldersExercises.sorted{ $0.name < $1.name }
        let sortedAbsArray = self.absExercises.sorted{ $0.name < $1.name }
   
        // append all of the muscle group arrays into one exercise array
        self.exerciseArray.append(contentsOf: [sortedAbsArray, sortedBicepArray, sortedTricepArray,
                                               sortedBackArray, sortedChestArray, sortedLegsArray,
                                               sortedShouldersArray])

        DispatchQueue.main.async {
            self.updateTheTable()
        }
 
    }
    
    //function to save the exercise items
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
        updateTheTable()
    }
    
    
    //Function to send the user's selected exercises to NewWorkoutViewController
    func addExercises(){
        
        self.delegate?.didLoadSelectedExercises(exercises: exercisesSelected)
        
    }
    

    //IB Action to send selected exercises to NewWorkoutViewController
    @IBAction func addExercisesButton(_ sender: UIButton) {
        
    
        //if statement to show if the exercisesSelected array is empty
        if exercisesSelected.isEmpty == true{
            //if array is empty it will show an alert to prompt the user to select exercises
            let alert = UIAlertController(title: "Select Exercises", message: "Please select your desired exercises for your workout.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        addExercises()
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
//    @IBAction func createExercisePressed(_ sender: UIBarButtonItem) {
//        self.performSegue(withIdentifier: "CreateExercise", sender: nil)
//
//    }
    

    // MARK: - Table view data source
    
    //returns number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exerciseArray.count
        
    }
    
    // returns the amount of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exerciseArray[section].count
        
    }
    
    //titles for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "Abs"
        } else if section == 1{
            return "Arms (Biceps)"
        } else if section == 2{
            return "Arms (Triceps)"
        } else if section == 3{
            return "Back"
        } else if section == 4{
            return "Chest"
        } else if section == 5{
            return "Legs"
        } else if section == 6{
            return "Shoulders"
        } else{
            return ""
        }
        
    }
    
    
    //returns the information displayed for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseNameCell", for: indexPath)
        cell.textLabel!.text = exerciseArray[indexPath.section][indexPath.row].name
        cell.textLabel!.textColor = UIColor.white
        cell.textLabel!.font = UIFont.systemFont(ofSize: 20.0)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.orange //set selected background to be orange
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    //when the accessory button is tapped, it sends the user to another view where the description of the exercise is displayed.
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        exerciseDescription = exerciseArray[indexPath.section][indexPath.row].description
        
        performSegue(withIdentifier: "ExerciseDescription", sender: tableView.cellForRow(at: indexPath))
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //when the user selects an exericse, the exercisesSelected array appends the exercise
        exercisesSelected.append(exerciseArray[indexPath.section][indexPath.row].name)
        
        exerciseDescription = (exerciseInfo?.Exercises[indexPath.row].description)!
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //when the user deselects an exericse, the exercisesSelected array removes the exercise
        if let index = exercisesSelected.firstIndex(of: exerciseArray[indexPath.section][indexPath.row].name) {
            exercisesSelected.remove(at: index)
        }
    }
    
    enum SegueIdentifier: String {

        case details = "ExerciseDescription"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue to the ExerciseDescriptionViewController to display the description for each exercise 
        switch segueIdentifier(for: segue) {
        case .details:
            _ = segue.destination as! ExerciseDescriptionViewController
            
        }
    }
     
}




    
    
    





