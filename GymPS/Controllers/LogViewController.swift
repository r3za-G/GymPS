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
    var cardioArray = [Cardio]()
    var workoutArray = [Workout]()
    
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Cardio Exercises"
        } else {
            return "Weightlifting Exercises"
        }
    }
    

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if section == 0 {
            return loadCardioExercise()?.count ?? 0
            } else {
                return loadWorkout()?.count ?? 0
            }
        }
        
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       

            if indexPath.section == 0{
                let cardioCell = tableView.dequeueReusableCell(withIdentifier: "LogCardioCell", for: indexPath) as? LogCardioTableCell
                let cardioExercise = loadCardioExercise()
                
                
                let cardio = cardioExercise?[indexPath.row]
                cardioCell?.cardio = cardio
                return cardioCell!
                
            } else {
                
                let workoutCell = tableView.dequeueReusableCell(withIdentifier: "LogWorkout", for: indexPath) as? LogWorkoutTableCell
                let workouts = loadWorkout()
                
                let workout = workouts?[indexPath.row]
                workoutCell?.workout = workout
                return workoutCell!
                
            }
        }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexRowSelected = indexPath.row

    }
    
    
    func saveExercise(){
        do{
            try context.save()
        } catch{
            print("error saving runs \(error)")
        }
        self.tableView.reloadData()
    }



    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                var cardio = loadCardioExercise()
                context.delete((cardio?[indexPath.row])!  )
                cardio?.remove(at: indexPath.row)
                tableView.reloadData()
                saveExercise()
            } else{
                var workout = loadWorkout()
                context.delete((workout?[indexPath.row])!  )
                workout?.remove(at: indexPath.row)
                tableView.reloadData()
                saveExercise()
            }
        }
        
    }
    
}


extension LogViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case detailsOne = "ShowCardioDetails"
        case detailsTwo = "ShowWorkoutDetails"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let indexPath = tableView.indexPathForSelectedRow
            switch segueIdentifier(for: segue) {
            case .detailsOne:
                let destination = segue.destination as! LogDetailsViewController
    
                destination.cardio = cardioArray.reversed()[indexPath!.row]
                
            case .detailsTwo:
                let destination = segue.destination as! LogWorkoutDetailsViewController
                destination.workout = workoutArray.reversed()[indexPath!.row]
            }
        
    }
}
