//
//  SettingsViewController.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import Foundation
import UIKit


class SettingsViewController: UITableViewController,  UITextFieldDelegate, ToolbarPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {


    @IBOutlet var metricTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!

    let weightMetricPicker = ToolbarPickerView()
    let numberWeigthPicker = ToolbarPickerView()


    let metricWeight = ["kg", "lb"]
    let numbers = ["0","1", "2", "3", "4", "5", "6","7", "8", "9"]
    let defaults = UserDefaults.standard


    var totalWeight = ""



    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
        
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


    func configureFields() {
        

        numberTextField.delegate = self
        metricTextField.delegate = self

        metricTextField.inputView = self.weightMetricPicker
        metricTextField.inputAccessoryView = self.weightMetricPicker.toolbar
        weightMetricPicker.dataSource = self
        weightMetricPicker.delegate = self
        weightMetricPicker.toolbarDelegate = self

        numberTextField.inputView = self.numberWeigthPicker
        numberTextField.inputAccessoryView = self.numberWeigthPicker.toolbar
        numberWeigthPicker.dataSource = self
        numberWeigthPicker.delegate = self
        numberWeigthPicker.toolbarDelegate = self

        tableView.dataSource = self
        tableView.delegate = self

        metricTextField.text = defaults.string(forKey:"Unit")
        numberTextField.text = defaults.string(forKey:"Weight")
        
        
    }


    func didTapDone() {
        
        let row = self.weightMetricPicker.selectedRow(inComponent: 0)
        self.weightMetricPicker.selectRow(row, inComponent: 0, animated: false)
        self.metricTextField.text = self.metricWeight[row]
        self.metricTextField.resignFirstResponder()

        let val1 = numbers[numberWeigthPicker.selectedRow(inComponent: 0)]
        let val2 = numbers[numberWeigthPicker.selectedRow(inComponent: 1)]
        let val3 = numbers[numberWeigthPicker.selectedRow(inComponent: 2)]

        if val1 == "0"{
            self.totalWeight = "\(val2)\(val3)"
        }else {
            self.totalWeight = "\(val1)\(val2)\(val3)"
        }

        let weight = self.totalWeight

        let unit = self.metricWeight[row]


        self.numberTextField.text = weight

        self.numberTextField.resignFirstResponder()

        
        defaults.set(unit, forKey: "Unit")
        defaults.set(weight, forKey: "Weight")
        
        
    }

    func didTapCancel() {
        self.metricTextField.text = nil
        self.metricTextField.resignFirstResponder()
        self.numberTextField.text = nil
        self.numberTextField.resignFirstResponder()

    }



    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weightMetricPicker{
            return self.metricWeight.count
        } else  {
            return self.numbers.count
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == weightMetricPicker {
            return 1
        } else {
            return 3
        }
    }



    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == weightMetricPicker {
            return self.metricWeight[row]
        } else {
            return self.numbers[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {


        if pickerView == weightMetricPicker {
            let unit = self.metricWeight[row]
            self.metricTextField.text = unit

        }

        let val1 = numbers[numberWeigthPicker.selectedRow(inComponent: 0)]
        let val2 = numbers[numberWeigthPicker.selectedRow(inComponent: 1)]
        let val3 = numbers[numberWeigthPicker.selectedRow(inComponent: 2)]

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






