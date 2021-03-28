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

        let setupWeight = UserDefaults.standard.bool(forKey: "SetupWeight")
        if !(setupWeight) {
            let alert = UIAlertController(title: "Input weight", message: "Please go to settings and input your weight to calculate calories burnt.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            if action.isEnabled == true {
                UserDefaults.standard.set(true, forKey: "SetupWeight")
            }
            self.present(alert, animated: true, completion: nil)

        }
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        
    }
    
    
}

