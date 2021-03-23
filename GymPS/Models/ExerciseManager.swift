//
//  ExerciseManager.swift
//  GymPS
//
//  Created by Reza Gharooni on 07/03/2021.
//




import Foundation


protocol ExerciseManagerDelegate {
    func didLoadExercise(_ exerciseManager: ExerciseManager, exercise: ExerciseData)
}



struct ExerciseManager{
    
    var delegate: ExerciseManagerDelegate?
    
    let exerciseURL = "https://student.csc.liv.ac.uk/~sgrgharo/data.php?class=Exercises"
    
    
    
    func fetchExercises(){
        let urlString = exerciseURL
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        if  let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
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
            
            task.resume()
        }
    }
    
    func parseJSON(_ exerciseData: Data) -> ExerciseData?{
        let decoder = JSONDecoder()
        do{
            
            let decodedData = try decoder.decode(ExerciseData.self, from: exerciseData)

//            for i in 0..<decodedData.Exercises.count{
//                count += 1
//                id = decodedData.Exercises[i].id
//                name = decodedData.Exercises[i].name
//                muscleGroup = decodedData.Exercises[i].muscleGroup
//                description = decodedData.Exercises[i].description
//                let exercises = ExerciseModel(id: id!, name: name!, muscleGroup: muscleGroup!, description: description!)
//            }

            
            let exercises = ExerciseData(Exercises: decodedData.Exercises)
            return exercises

        } catch {
            print(error)
            return nil
        }
        
    }
    
    
    
}
