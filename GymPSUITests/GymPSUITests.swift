//
//  GymPSUITests.swift
//  GymPSUITests
//
//  Created by Reza Gharooni on 28/02/2021.
//

import XCTest
import ValueStepper

class GymPSUITests: XCTestCase {
    
    var valueStepper = ValueStepper()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testCardioExercise(){
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.staticTexts["ENTER"]/*[[".buttons[\"ENTER\"].staticTexts[\"ENTER\"]",".staticTexts[\"ENTER\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["PICK CARDIO TYPE!"].scrollViews.otherElements.buttons["OK"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
        app.sheets["Pick Cardio Type"].scrollViews.otherElements.buttons["Run"].tap()
        
        let element2 = element.children(matching: .other).element(boundBy: 3)
        let button = element2.children(matching: .button).element
        button.tap()
        button.tap()
        element2.children(matching: .button).element(boundBy: 1).tap()
        app.sheets["End exercise?"].scrollViews.otherElements.buttons["Save"].tap()
       
    
    }
    
    func testSetUserWeight(){
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Settings"].tap()
        
      
        
        let cellsQuery = app.tables.cells
        cellsQuery.children(matching: .textField).element(boundBy: 0).tap()
        
        let weightUnitTextField =  cellsQuery.children(matching: .textField).element(boundBy: 0)
        XCTAssertTrue(weightUnitTextField.exists)
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        cellsQuery.children(matching: .textField).element(boundBy: 1).tap()
        
        let numberTextField = cellsQuery.children(matching: .textField).element(boundBy: 1)
        XCTAssertTrue(numberTextField.exists)
        
        app.pickers.children(matching: .pickerWheel).matching(identifier: "0").element(boundBy: 1).swipeUp()
        doneButton.tap()
        
    }
    
 
    
    func testCreateWorkout(){
        
        
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Workout"].tap()
        app.navigationBars["WORKOUTS"].buttons["Create New"].tap()
        app/*@START_MENU_TOKEN@*/.textFields["Workout Name"]/*[[".otherElements[\"AddWorkoutTableViewController\"].textFields[\"Workout Name\"]",".textFields[\"Workout Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let pKey = app/*@START_MENU_TOKEN@*/.keys["P"]/*[[".keyboards.keys[\"P\"]",".keys[\"P\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()
    
        
        let uKey = app/*@START_MENU_TOKEN@*/.keys["u"]/*[[".keyboards.keys[\"u\"]",".keys[\"u\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        uKey.tap()
   
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()

        
        let hKey = app/*@START_MENU_TOKEN@*/.keys["h"]/*[[".keyboards.keys[\"h\"]",".keys[\"h\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey.tap()
     
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Add Exercise"]/*[[".otherElements[\"AddWorkoutTableViewController\"]",".buttons[\"Add Exercise\"].staticTexts[\"Add Exercise\"]",".staticTexts[\"Add Exercise\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Cable Curl"]/*[[".otherElements[\"AddExerciseTableViewController\"].tables",".cells.staticTexts[\"Cable Curl\"]",".staticTexts[\"Cable Curl\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Hammer Curl"]/*[[".otherElements[\"AddExerciseTableViewController\"].tables",".cells.staticTexts[\"Hammer Curl\"]",".staticTexts[\"Hammer Curl\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Spider Curl"]/*[[".otherElements[\"AddExerciseTableViewController\"].tables",".cells.staticTexts[\"Spider Curl\"]",".staticTexts[\"Spider Curl\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Pull-up"]/*[[".otherElements[\"AddExerciseTableViewController\"].tables",".cells.staticTexts[\"Pull-up\"]",".staticTexts[\"Pull-up\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["ADD"]/*[[".otherElements[\"AddExerciseTableViewController\"]",".buttons[\"ADD\"].staticTexts[\"ADD\"]",".staticTexts[\"ADD\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let cableCurlStaticText = app/*@START_MENU_TOKEN@*/.tables.staticTexts["Cable Curl"]/*[[".otherElements[\"AddWorkoutTableViewController\"].tables",".cells.staticTexts[\"Cable Curl\"]",".staticTexts[\"Cable Curl\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        cableCurlStaticText.tap()
        cableCurlStaticText.tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Hammer Curl"]/*[[".otherElements[\"AddWorkoutTableViewController\"].tables",".cells.staticTexts[\"Hammer Curl\"]",".staticTexts[\"Hammer Curl\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Pull-up"]/*[[".otherElements[\"AddWorkoutTableViewController\"].tables",".cells.staticTexts[\"Pull-up\"]",".staticTexts[\"Pull-up\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        app.navigationBars["GymPS.NewWorkoutView"].buttons["SAVE"].tap()
 
      
    }
    

  
    
    func testViewSavedCardioExercises() {
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Log"].tap()
      
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["0.00"]/*[[".otherElements[\"LogViewController\"].tables",".cells.staticTexts[\"0.00\"]",".staticTexts[\"0.00\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Error"].scrollViews.otherElements.buttons["OK"].tap()
        let logButton = app.navigationBars["YOUR STATS"].buttons["LOG"]
        logButton.tap()

                
        
    }
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
