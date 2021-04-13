//
//  GymPSTests.swift
//  GymPSTests
//
//  Created by Reza Gharooni on 28/02/2021.
//

import XCTest
@testable import GymPS

class GymPSTests: XCTestCase {
    
    var sut: LogWorkoutDetailsViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = LogWorkoutDetailsViewController()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testCalculateTotalSets(){
        
        var setsArray = sut.setsArray
        
        setsArray = [2, 5, 7, 9]
        
        XCTAssertEqual(setsArray.sum(), 23)
        
    }
  


}

