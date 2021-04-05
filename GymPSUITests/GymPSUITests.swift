//
//  GymPSUITests.swift
//  GymPSUITests
//
//  Created by Reza Gharooni on 28/02/2021.
//

import XCTest

class GymPSUITests: XCTestCase {

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

    
    func testStartRun(){
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.staticTexts["ENTER"]/*[[".buttons[\"ENTER\"].staticTexts[\"ENTER\"]",".staticTexts[\"ENTER\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["PICK CARDIO TYPE!"].scrollViews.otherElements.buttons["OK"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
        app.sheets["Pick Cardio Type"].scrollViews.otherElements.buttons["Run"].tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .button).element.tap()
    
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
    
    func testSaveCardio(){
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.staticTexts["ENTER"]/*[[".buttons[\"ENTER\"].staticTexts[\"ENTER\"]",".staticTexts[\"ENTER\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
        app.sheets["Pick Cardio Type"].scrollViews.otherElements.buttons["Cycle"].tap()
        
        let element2 = element.children(matching: .other).element(boundBy: 2)
        let button = element2.children(matching: .button).element
        button.tap()
        button.tap()
        element2.children(matching: .button).element(boundBy: 1).tap()
        
        let stopButton = element2.children(matching: .button).element(boundBy: 1)
        XCTAssertTrue(stopButton.exists)
        
        app.sheets["End exercise?"].scrollViews.otherElements.buttons["Save"].tap()
        
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
