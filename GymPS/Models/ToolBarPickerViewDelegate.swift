//
//  ToolBarPickerViewDelegate.swift
//  GymPS
//
//  Created by Reza Gharooni on 01/03/2021.
//

import Foundation
import UIKit



class ToolbarPickerView: UIPickerView {
    
    //set the toolbar to be a UIToolBar
    public private(set) var toolbar: UIToolbar?
    public weak var toolBarDelegate: ToolBarPickerViewDelegate?
    
    //initialise tool bar
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialiseToolbar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialiseToolbar()
    }
    
    //func to create and initialise toolbar
    private func initialiseToolbar() {
        let toolBarView = UIToolbar()
        toolBarView.barStyle = UIBarStyle.default
        toolBarView.tintColor = .black
        toolBarView.isTranslucent = true
        toolBarView.sizeToFit()
        
        //create done, space and cancel buttons
        let doneB = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.tappedDone))
        let spaceB = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelB = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.tappedCance))
        
        //set the items
        toolBarView.setItems([cancelB, spaceB, doneB], animated: false)
        toolBarView.isUserInteractionEnabled = true
        
        self.toolbar = toolBarView
    }
    
    //function for tapped done
    @objc func tappedDone() {
        self.toolBarDelegate?.doneButtonTapped()
    }
    
    //function for tapped cancel
    @objc func tappedCance() {
        self.toolBarDelegate?.cancelButtonTapped()
    }
}

//delegate protocol method for the toolbar picker

protocol ToolBarPickerViewDelegate: class {
    func doneButtonTapped()
    func cancelButtonTapped()
}
