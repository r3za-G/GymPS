//
//  CardioHomeViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import UIKit

class CardioHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let setupWeight = UserDefaults.standard.bool(forKey: "SetupWeight") //Use User defaults to allow a pop message when the app is launched the very first time
                                                                            //Handle this by using an if statement then setting the User default to true so that the if statement is not triggered again
        if !(setupWeight) {
            
            let alert = UIAlertController(title: "Input weight", message: "Please go to settings and input your weight to calculate calories burnt.", preferredStyle: .alert)
            //Present a custom alert tell the user to input their weight
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            if action.isEnabled == true {
                UserDefaults.standard.set(true, forKey: "SetupWeight") //Set the User Default value to be true
            }
            self.present(alert, animated: true, completion: nil)

        }
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        navigationController?.navigationBar.barTintColor = UIColor.black
    
    }
  
}

