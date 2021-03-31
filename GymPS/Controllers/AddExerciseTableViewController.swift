//
//  AddExerciseTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit
import CoreData


protocol SelectedExercisesDelegate {
    func didLoadSelectedExercises(exercises: [String])
}



var exerciseDescription = ""

class AddExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExerciseManagerDelegate, UITextFieldDelegate, SegueHandlerType, CreatedExerciseDelegate{
    
    
    @IBOutlet var exerciseTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var exerciseManager = ExerciseManager()
    var delegate: SelectedExercisesDelegate?
    var exerciseInfo: ExerciseData? = nil
    
    var chestExercises: [(name: String, muscleGroup: String, description: String)] = []
    var bicepExercises: [(name: String, muscleGroup: String, description: String)] = []
    var tricepExercises: [(name: String, muscleGroup: String, description: String)] = []
    var backExercises: [(name: String, muscleGroup: String, description: String)] = []
    var legsExercises: [(name: String, muscleGroup: String, description: String)] = []
    var shouldersExercises: [(name: String, muscleGroup: String, description: String)] = []
    var absExercises: [(name: String, muscleGroup: String, description: String)] = []
    var exercisesSelected: [String] = []
    var exerciseArray = [[(name: String, muscleGroup: String, description: String)]]()
    var filteredExercises = [[(name: String, muscleGroup: String, description: String)]]()
    var loadedSavedArray = [[(name: String, muscleGroup: String, description: String)]]()
//    var loadedSavedArray = [[String]]()
    var createdExerciseArray = [String]()
    
    var loadedExerciseArray = [Exercise]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "AddExerciseTableViewController"
        
        searchBar.delegate = self
        exerciseManager.delegate = self
        exerciseManager.fetchExercises()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
    
        
        self.loadedExerciseArray = loadExercise()!

        
//        for i in loadedExerciseArray{
//            let setsStringAsData = i.savedExerciseArray!.data(using: String.Encoding.utf16)
//            self.loadedSavedArray = try! JSONDecoder().decode([[String]].self, from: setsStringAsData!)
//
//        }
//        print(loadedSavedArray)
   
    }
 
    
    
    
    func updateTheTable() {
        exerciseTable.reloadData()
    }
    
    func didLoadExercise(_ exerciseManager: ExerciseManager, exercise: ExerciseData)  {
        
        self.exerciseInfo = exercise
        
        if exerciseInfo?.Exercises != nil{
            for n in 0..<(exerciseInfo!.Exercises.count){
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
    
        let sortedChestArray = self.chestExercises.sorted{ $0.name < $1.name }
        let sortedBicepArray = self.bicepExercises.sorted{ $0.name < $1.name }
        let sortedTricepArray = self.tricepExercises.sorted{ $0.name < $1.name }
        let sortedBackArray = self.backExercises.sorted{ $0.name < $1.name }
        let sortedLegsArray = self.legsExercises.sorted{ $0.name < $1.name }
        let sortedShouldersArray = self.shouldersExercises.sorted{ $0.name < $1.name }
        let sortedAbsArray = self.absExercises.sorted{ $0.name < $1.name }
   
        self.exerciseArray.append(contentsOf: [sortedAbsArray, sortedBicepArray, sortedTricepArray,
                                               sortedBackArray, sortedChestArray, sortedLegsArray,
                                               sortedShouldersArray])
        
        
        
        filteredExercises = exerciseArray
        

        
        DispatchQueue.main.async {
            
            self.saveArray()
            self.updateTheTable()
        }
 
    }
    
    
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving items \(error)")
        }
        updateTheTable()
    }
    
    
    func loadExercise() -> [Exercise]?{
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do{
            loadedExerciseArray = try context.fetch(request)
            return loadedExerciseArray
        }catch {
            print("error fetching data \(error)")
        }
        return loadedExerciseArray
    }
    
    func saveArray(){
        
        let savedArray = UserDefaults.standard.bool(forKey: "savedArray")
        if !(savedArray){
            let savedExerciseArray = Exercise(context: context)
            let exerciseArrayAsString: String = filteredExercises.description
            savedExerciseArray.savedExerciseArray = exerciseArrayAsString
            self.saveItems()
            UserDefaults.standard.set(true, forKey: "savedArray")
        }
    }
    
    
    func didLoadCreatedExercise(createdExercise: [String]) {
        
        self.createdExerciseArray = createdExercise
        
//        print(createdExerciseArray)
        
        //        if !(createdExerciseArray.isEmpty) == true{
        //            if createdExerciseArray.contains("Chest"){
        //                self.chestExercises.append(createdExerciseArray[0])
        //                self.chestDescription.append(createdExerciseArray[2])
        //            } else if createdExerciseArray.contains("Arms (Biceps)"){
        //                self.bicepExercises.append(createdExerciseArray[0])
        //                self.bicepDescription.append(createdExerciseArray[2])
        //            } else if createdExerciseArray.contains("Arms (Triceps)"){
        //                self.tricepExercises.append(createdExerciseArray[0])
        //                self.tricepDescription.append(createdExerciseArray[2])
        //            } else if createdExerciseArray.contains("Back"){
        //                self.backExercises.append(createdExerciseArray[0])
        //                self.backDescription.append(createdExerciseArray[2])
        //            } else if createdExerciseArray.contains("Legs"){
        //                self.legsExercises.append(createdExerciseArray[0])
        //                self.legsDescription.append(createdExerciseArray[2])
        //            } else if createdExerciseArray.contains("Shoulders"){
        //                self.shouldersExercises.append(createdExerciseArray[0])
        //                self.shouldersDescription.append(createdExerciseArray[2])
        //            } else if createdExerciseArray.contains("Abs"){
        //                self.absExercises.append(createdExerciseArray[0])
        //                self.absDescription.append(createdExerciseArray[2])
        //            }
        //        }
        
        
        
        self.updateTheTable()
        
    }
    
    
    func addExercises(){
        
        self.delegate?.didLoadSelectedExercises(exercises: exercisesSelected)
        
    }
    
    
    
    
    @IBAction func addExercisesButton(_ sender: UIButton) {
        
        if exercisesSelected.isEmpty == true{
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
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return filteredExercises.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredExercises[section].count
        
    }
    
    
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
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseNameCell", for: indexPath)
        cell.textLabel!.text = filteredExercises[indexPath.section][indexPath.row].name
        cell.textLabel!.textColor = UIColor.white
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        exerciseDescription = exerciseArray[indexPath.section][indexPath.row].description
        
        performSegue(withIdentifier: "ExerciseDescription", sender: tableView.cellForRow(at: indexPath))
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        exercisesSelected.append(filteredExercises[indexPath.section][indexPath.row].name)
        
        exerciseDescription = (exerciseInfo?.Exercises[indexPath.row].description)!
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let index = exercisesSelected.firstIndex(of: filteredExercises[indexPath.section][indexPath.row].name) {
            // changed to firstindex
            exercisesSelected.remove(at: index)
        }
    }
     
}


//MARK: - Search bar methods
extension AddExerciseTableViewController: UISearchBarDelegate {
    
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//
//            filteredExercises = [[]]
//
//
//
//
//
//            if searchText == ""{
//                filteredExercises = exerciseArray
//            }
//            else{
//                for var exercises in exerciseArray{
//                    for exerciseName in exercises{
//                        if exerciseName.name.lowercased().contains(searchText.lowercased()){
//
//                            exercises.append((name: exerciseName.name, muscleGroup: exerciseName.muscleGroup, description: exerciseName.description))
//                            print(exercises)
//
//                        }
//                        filteredExercises.append(exercises)
//                    }
//                }
//            }
//
//
//
//            }


    enum SegueIdentifier: String {
        case detailsOne = "CreateExercise"
        case detailsTwo = "ExerciseDescription"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(for: segue) {
        case .detailsOne:
            let createExercise = segue.destination as! CreateExerciseViewController
            createExercise.delegate = self
        case .detailsTwo:
            _ = segue.destination as! ExerciseDescriptionViewController
        }
    }
    
}




