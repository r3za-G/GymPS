//
//  ExerciseManager.swift
//  GymPS
//
//  Created by Reza Gharooni on 07/03/2021.
//

import Foundation

//Delegate protocol method to send the exercise data to AddExerciseViewController
protocol ExerciseManagerDelegate {
    //function takes in two parameters, ExerciseManager and ExerciseData
    func didLoadExercise(_ exerciseManager: ExerciseManager, exercise: ExerciseData)
}


struct ExerciseManager{
    
    var delegate: ExerciseManagerDelegate? //setting the delegate variable
    
    //URL to the exercise API where the exercise JSON data is held
    let exerciseURL = "https://student.csc.liv.ac.uk/~sgrgharo/data.php?class=Exercises"
    
    //function to fetch the exercises and request the url
    func fetchExercises(){
        let urlString = exerciseURL
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        //1. Create URL
        
        if  let url = URL(string: urlString){
            //2. Create URLsession
            
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let exercises = self.parseJSON(safeData){
                        self.delegate?.didLoadExercise(self, exercise: exercises)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    //fucntion to parse the JSON data
    func parseJSON(_ exerciseData: Data) -> ExerciseData?{
        let decoder = JSONDecoder()
        do{
            // decodes the data using our codable ExerciseData struct
            let decodedData = try decoder.decode(ExerciseData.self, from: exerciseData)
            let exercises = ExerciseData(Exercises: decodedData.Exercises)
            return exercises
            //returns the decoded exercises

        } catch {
            print(error)
            return nil
        }
        
    }
    
    
    
}
