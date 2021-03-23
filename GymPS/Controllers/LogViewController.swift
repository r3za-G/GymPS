//
//  LogViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import UIKit
import CoreData

class LogViewController: UITableViewController{
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cardioArray = [Cardio]()
    
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
                cardioArray = try context.fetch(request)
                return cardioArray.reversed()
            }catch {
                print("error fetching data \(error)")
            }
            return cardioArray
        }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return loadCardioExercise()?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       

        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as? LogTableViewCell,
            let cardioExercise = loadCardioExercise()
            else { return UITableViewCell() }
        
        let cardio = cardioExercise[indexPath.row]
        cell.cardio = cardio
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexRowSelected = indexPath.row
        

    }
    
    
    func saveCardioExercise(){
        do{
            try context.save()
        } catch{
            print("error saving runs \(error)")
        }
        self.tableView.reloadData()
    }



    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard var cardio = loadCardioExercise() else { return }
            context.delete(cardio[indexPath.row])
            cardio.remove(at: indexPath.row)
            tableView.reloadData()
            saveCardioExercise()
        }
    }
}




extension LogViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "ShowCardioDetails"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let indexPath = tableView.indexPathForSelectedRow
            switch segueIdentifier(for: segue) {
            case .details:
                let destination = segue.destination as! LogDetailsViewController
    
                destination.cardio = cardioArray.reversed()[indexPath!.row]
                
            }
        
    }
}
