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

//create a struct for the exercise array displayed to the user
struct ExerciseArray: Codable {
    var name: String
    var muscleGroup: String
    var description: String
}

var exerciseDescription = ""

class AddExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExerciseManagerDelegate, UITextFieldDelegate, SegueHandlerType, CreatedExerciseDelegate {
    

    @IBOutlet var exerciseTable: UITableView!
    
    var exerciseManager = ExerciseManager()
    var delegate: SelectedExercisesDelegate? // variable delegate
    var exerciseInfo: ExerciseData? = nil
    var exercise: Exercise!
    
    //arrays for each specific muscle group
    var chestExercises: [ExerciseArray] = []
    var bicepExercises: [ExerciseArray] = []
    var tricepExercises: [ExerciseArray] = []
    var backExercises: [ExerciseArray] = []
    var legsExercises: [ExerciseArray] = []
    var shouldersExercises: [ExerciseArray] = []
    var absExercises: [ExerciseArray] = []
    var exercisesSelected: [String] = []
    var exerciseArray = [[ExerciseArray]]()
    var loadExercises: [Exercise]!
    
    var exercisesSaved = [ExerciseData]()
    
    var savedExerciseNames = [String]()
    var savedExerciseMuscleGroup = [String]()
    var savedExerciseDescriptions = [String]()
    var loadSavedNames = [String]()
    var loadSavedMuscleGroup = [String]()
    var loadSavedDescriptions = [String]()
    var loadedExerciseArray = [ExerciseArray]()
    var savedCreatedExerciseName = [String]()
    var savedCreatedExerciseMG = [String]()
    var savedCreatedExerciseDescription = [String]()
    var savedExerciseNameString = ""
    var savedExerciseMGString = ""
    var savedExerciseDescriptionString = ""
    
    var createdExerciseArray = [String]()

    
    
    
    
    
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


    //function to load the saved exercise array from core data
    func configureArray(){
        
        self.loadExercises = loadExerciseArray()
        
        loadSavedNames.removeAll()
        loadSavedMuscleGroup.removeAll()
        loadSavedDescriptions.removeAll()
        
        //for-loop to append the exercise data to their arrays
        for x in loadExercises{

            loadSavedNames.append(x.name!)
            loadSavedMuscleGroup.append(x.muscleGroup!)
            loadSavedDescriptions.append(x.exerciseDescription!)
            
        }
      
        
        loadedExerciseArray.removeAll()
        //zip the three arrays together to create one exercise array called loadedExerciseArray
        for (names, muscleGroups, descriptions) in zip3(loadSavedNames, loadSavedMuscleGroup, loadSavedDescriptions){
            self.loadedExerciseArray.append(ExerciseArray.init(name: names, muscleGroup: muscleGroups, description: descriptions))
        }
        
        //for loop to iterate over the exercise info array and append each respected name/muscle groups/descriptions to their own array
        
        chestExercises.removeAll()
        bicepExercises.removeAll()
        tricepExercises.removeAll()
        backExercises.removeAll()
        legsExercises.removeAll()
        shouldersExercises.removeAll()
        absExercises.removeAll()
        
        for n in loadedExerciseArray{
            if n.muscleGroup == "Chest"{
                self.chestExercises.append(ExerciseArray.init(name: n.name, muscleGroup: n.muscleGroup, description: n.description))
            }
            if n.muscleGroup == "Arms (Biceps)"{
                self.bicepExercises.append(ExerciseArray.init(name: n.name, muscleGroup: n.muscleGroup, description: n.description))
            }
            if n.muscleGroup == "Arms (Triceps)"{
                self.tricepExercises.append(ExerciseArray.init(name: n.name, muscleGroup: n.muscleGroup, description: n.description))
            }
            if n.muscleGroup == "Back"{
                self.backExercises.append(ExerciseArray.init(name: n.name, muscleGroup: n.muscleGroup, description: n.description))
            }
            if n.muscleGroup == "Legs"{
                self.legsExercises.append(ExerciseArray.init(name: n.name, muscleGroup: n.muscleGroup, description: n.description))
            }
            if n.muscleGroup == "Shoulders"{
                self.shouldersExercises.append(ExerciseArray.init(name: n.name, muscleGroup: n.muscleGroup, description: n.description))
            }
            if n.muscleGroup == "Abs"{
                self.absExercises.append(ExerciseArray.init(name: n.name, muscleGroup: n.muscleGroup, description: n.description))
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
        
        
        exerciseArray.removeAll()
        // append all of the muscle group arrays into one exercise array
        self.exerciseArray.append(contentsOf: [sortedAbsArray, sortedBicepArray, sortedTricepArray,
                                               sortedBackArray, sortedChestArray, sortedLegsArray,
                                               sortedShouldersArray])

    }
    
 

    //function to reload data in the tableview
    func updateTheTable() {
  
        exerciseTable.reloadData()
       
    
    }
    
    //Delegate protocol function from ExerciseManager. This is where the exercise data called from the API is received and manipiulated so the user can view it.
    func didLoadExercise(_ exerciseManager: ExerciseManager, exercise: ExerciseData)  {
        
        self.exerciseInfo = exercise
        let savedArray = UserDefaults.standard.bool(forKey: "savedArray")
        
        
        //save the exercises information only once when the user first laods the app up
        //I have done this incase the data from the API url cannot be reached (if the university server is down)
        if exerciseInfo?.Exercises != nil{
            self.exercisesSaved.append(ExerciseData.init(Exercises: exerciseInfo!.Exercises))
            for n in 0..<(exerciseInfo!.Exercises.count){   //for loop to iterate over the exercise info array
                //append to each array which will get saved to core data
                
                self.savedExerciseNames.append((exerciseInfo?.Exercises[n].name)!)
                self.savedExerciseMuscleGroup.append((exerciseInfo?.Exercises[n].muscleGroup)!)
                self.savedExerciseDescriptions.append((exerciseInfo?.Exercises[n].description)!)
                
                if !(savedArray) {

                    let savedExercises = Exercise(context: self.context)
                    savedExercises.name = exerciseInfo?.Exercises[n].name
                    savedExercises.muscleGroup = exerciseInfo?.Exercises[n].muscleGroup
                    savedExercises.exerciseDescription = exerciseInfo?.Exercises[n].description
                    self.saveItems()
                    
                    
                    UserDefaults.standard.set(true, forKey: "savedArray")
   
                }
                
            }
        }
        
        DispatchQueue.main.async {
            self.configureArray()   //Load the exercises from core data
            self.updateTheTable()
        }
    }
    
    //delegate function to retrieve the created exercise from the user
    func didLoadCreatedExercise(createdExercise: [String]) {

        self.createdExerciseArray = createdExercise

        //save the created exercise to core data
        
      
        
        let savedExercises = Exercise(context: self.context)
        savedExercises.name = self.createdExerciseArray[0]
        savedExercises.muscleGroup = self.createdExerciseArray[1]
        savedExercises.exerciseDescription = self.createdExerciseArray[2]
        self.saveItems()
        
        configureArray()
        updateTheTable()

    }
    

    //function to save the exercise items
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
    }
    
    // function to laod the saved exercises from Core Data, and return them as an array.
    func loadExerciseArray() -> [Exercise]?{
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do{
            loadExercises = try context.fetch(request)
            return loadExercises
        }catch {
            print("error fetching data \(error)")
        }
        return loadExercises
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
    
    
    @IBAction func createExercisePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CreateExercise", sender: nil)
        
        
    }
    
    
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
        case detailsTwo = "createExercise"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue to the ExerciseDescriptionViewController to display the description for each exercise 
        switch segueIdentifier(for: segue) {
        case .details:
            _ = segue.destination as! ExerciseDescriptionViewController
            
        case .detailsTwo:
            let createExercise = segue.destination as! CreateExerciseViewController
            createExercise.delegate = self
        }
        
        
    }
    
}












