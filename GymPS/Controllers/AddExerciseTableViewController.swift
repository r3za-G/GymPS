//
//  AddExerciseTableViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 04/03/2021.
//

import Foundation
import UIKit


protocol SelectedExercisesDelegate {
    func didLoadSelectedExercises(exercises: [String])
}

class AddExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExerciseManagerDelegate, UITextFieldDelegate{
    
    
    
    @IBOutlet var exerciseTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var exerciseManager = ExerciseManager()
    
    var delegate: SelectedExercisesDelegate?
    
    
    var exerciseInfo: ExerciseData? = nil
    
    
    var chestExercises: [String] = []
    var bicepExercises: [String] = []
    var tricepExercises: [String] = []
    var backExercises: [String] = []
    var legsExercises: [String] = []
    var shouldersExercises: [String] = []
    var absExercises: [String] = []
    
    
    
    var exercisesSelected: [String] = []
    
    var exerciseArray = [[String]]()
    var filteredExercises = [[String]]()
    
    
    //    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "AddExerciseTableViewController"
        
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        searchBar.delegate = self
        exerciseManager.delegate = self
        exerciseManager.fetchExercises()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        
    }
    
    func updateTheTable() {
        exerciseTable.reloadData()
    }
    
    func didLoadExercise(_ exerciseManager: ExerciseManager, exercise: ExerciseData)  {
        
        self.exerciseInfo = exercise
        
        if exerciseInfo?.Exercises != nil{
            for n in 0..<(exerciseInfo!.Exercises.count){
                if exerciseInfo!.Exercises[n].muscleGroup == "Chest"{
                    self.chestExercises.append(exerciseInfo!.Exercises[n].name)
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Arms (Biceps)"{
                    self.bicepExercises.append(exerciseInfo!.Exercises[n].name)
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Arms (Triceps)" {
                    self.tricepExercises.append(exerciseInfo!.Exercises[n].name)
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Back" {
                    self.backExercises.append(exerciseInfo!.Exercises[n].name)
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Legs" {
                    self.legsExercises.append(exerciseInfo!.Exercises[n].name)
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Shoulders" {
                    self.shouldersExercises.append(exerciseInfo!.Exercises[n].name)
                }
                if exerciseInfo!.Exercises[n].muscleGroup == "Abs" {
                    self.absExercises.append(exerciseInfo!.Exercises[n].name)
                }
            }
        }
        self.exerciseArray.append(chestExercises)
        self.exerciseArray.append(bicepExercises)
        self.exerciseArray.append(tricepExercises)
        self.exerciseArray.append(backExercises)
        self.exerciseArray.append(legsExercises)
        self.exerciseArray.append(shouldersExercises)
        self.exerciseArray.append(absExercises)
        
        
        
        filteredExercises = exerciseArray
        
        
        DispatchQueue.main.async {
            self.updateTheTable()
        }
        
    }
    
    
    func addExercises(){
        
        self.delegate?.didLoadSelectedExercises(exercises: exercisesSelected)
        
    }
    
    
    
    
    @IBAction func addExercisesButton(_ sender: UIButton) {
        
        addExercises()
        self.navigationController?.popViewController(animated: false)
        
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
            return "Chest"
        } else if section == 1{
            return "Arms (Biceps)"
        } else if section == 2{
            return "Arms (Triceps)"
        } else if section == 3{
            return "Back"
        } else if section == 4{
            return "Legs"
        } else if section == 5{
            return "Shoulders"
        } else if section == 6{
            return "Abs"
        } else{
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseNameCell", for: indexPath)
        cell.textLabel!.text = filteredExercises[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        exercisesSelected.append(filteredExercises[indexPath.section][indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let index = exercisesSelected.firstIndex(of: filteredExercises[indexPath.section][indexPath.row]) {
            // changed to firstindex
            exercisesSelected.remove(at: index)
        }
    }
}


////MARK: - Picker view methods
//extension AddExerciseTableViewController: ToolbarPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
//    func didTapDone() {
//
//    }
//
//    func didTapCancel() {
//
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 3
//    }
//
//}



//MARK: - Search bar methods
extension AddExerciseTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        filteredExercises = [[]]
        
        
        if searchText == ""{
            filteredExercises = exerciseArray
        }
        else{
            for exercises in exerciseArray{
                for name in exercises{
                    if name.lowercased().contains(searchText.lowercased()){
                        filteredExercises.append([name])
                    }
                    
                }
            }
        }
        print(filteredExercises)
        
        updateTheTable()
        
    }
    
}




