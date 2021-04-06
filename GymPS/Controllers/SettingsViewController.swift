//
//  SettingsViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import Foundation
import UIKit


class SettingsViewController: UITableViewController,  UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ToolBarPickerViewDelegate {


    @IBOutlet var metricTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!

    let weightMetricPicker = ToolbarPickerView()    // custom toolbar pickerview
    let numberWeigthPicker = ToolbarPickerView()    // custom toolbar pickerview


    let metricWeight = ["kg", "lb"] //unit picker view array
    let numbers = ["0","1", "2", "3", "4", "5", "6","7", "8", "9"] //numbers picker view array
    let defaults = UserDefaults.standard //User defaults variable


    var totalWeight = ""



    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields() //calling this method to show the default weight and unit
        
        if metricTextField.text == ""{
            metricTextField.text = "Weight Units"
        }
        if numberTextField.text == ""{
            numberTextField.text = "0"
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    //function to configure the texts views, picker views and display the default unit and weight
    func configureFields() {
        
        //making the text fields both delegates
        numberTextField.delegate = self
        metricTextField.delegate = self

        metricTextField.inputView = self.weightMetricPicker //As the user presses the text view, the picker view will be presented
        metricTextField.inputAccessoryView = self.weightMetricPicker.toolbar
        weightMetricPicker.dataSource = self
        weightMetricPicker.delegate = self
        weightMetricPicker.toolBarDelegate = self

        numberTextField.inputView = self.numberWeigthPicker //As the user presses the text view, the picker view will be presented
        numberTextField.inputAccessoryView = self.numberWeigthPicker.toolbar
        numberWeigthPicker.dataSource = self
        numberWeigthPicker.delegate = self
        numberWeigthPicker.toolBarDelegate = self

        tableView.dataSource = self
        tableView.delegate = self

        metricTextField.text = defaults.string(forKey:"Unit")   //default value for unit
        numberTextField.text = defaults.string(forKey:"Weight") //default value for weight
        
        
    }

    //protocol function for the delegate method ToolbarPickerViewDelegate
    func doneButtonTapped() {
        
        
        let row = self.weightMetricPicker.selectedRow(inComponent: 0)
        self.weightMetricPicker.selectRow(row, inComponent: 0, animated: false)
        self.metricTextField.text = self.metricWeight[row] //value for the weight unit
        self.metricTextField.resignFirstResponder()
        
        //three values for the numeric weight the user picks
        let val1 = numbers[numberWeigthPicker.selectedRow(inComponent: 0)]
        let val2 = numbers[numberWeigthPicker.selectedRow(inComponent: 1)]
        let val3 = numbers[numberWeigthPicker.selectedRow(inComponent: 2)]

        //if statement to only give the latter two digits if the first is 0
        if val1 == "0"{
            self.totalWeight = "\(val2)\(val3)"
        }else {
            self.totalWeight = "\(val1)\(val2)\(val3)"
        }

        let weight = self.totalWeight

        let unit = self.metricWeight[row]


        self.numberTextField.text = weight

        self.numberTextField.resignFirstResponder()

        
        defaults.set(unit, forKey: "Unit") // setting the user default when the user presses done
        defaults.set(weight, forKey: "Weight") // setting the user default when the user presses done
        
        
    }
    
 
   

    //protocol function for the delegate method ToolbarPickerViewDelegate
    func cancelButtonTapped() {
        self.metricTextField.text = nil //leaving the textfield as it is if the user presses cancel
        self.metricTextField.resignFirstResponder()
        self.numberTextField.text = nil //leaving the textfield as it is if the user presses cancel
        self.numberTextField.resignFirstResponder()

    }


//MARK: - Picker view data source
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weightMetricPicker{    //if-statement to return the amount of rows for each picker view
            return self.metricWeight.count
        } else  {
            return self.numbers.count
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == weightMetricPicker {   // returns the amount of components for each picker view
            return 1
        } else {
            return 3
        }
    }



    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == weightMetricPicker {   // returns the two string arrays for each picker view
            return self.metricWeight[row]
        } else {
            return self.numbers[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {


        if pickerView == weightMetricPicker {   //method to return which rows the user have selected for each picker view
            let unit = self.metricWeight[row]
            self.metricTextField.text = unit

        }

        let val1 = numbers[numberWeigthPicker.selectedRow(inComponent: 0)]
        let val2 = numbers[numberWeigthPicker.selectedRow(inComponent: 1)]
        let val3 = numbers[numberWeigthPicker.selectedRow(inComponent: 2)]

        //if statement to only give the latter two digits if the first is 0
        if pickerView == numberWeigthPicker {

            if val1 == "0"{
                let totalWeight = "\(val2)\(val3)"
                return self.numberTextField.text = totalWeight
            } else {
                let totalWeight = "\(val1)\(val2)\(val3)"
                return self.numberTextField.text = totalWeight
            }
        }

    }

}






