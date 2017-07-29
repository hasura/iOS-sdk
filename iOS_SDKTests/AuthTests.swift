//
//  iOS_SDKTests.swift
//  iOS_SDKTests
//
//  Created by Jaison on 26/06/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import XCTest
@testable import Hasura

class AuthTests: BaseTest {
    
    override func setUp() {
        super.setUp()
        
        user.username = "jaison"
        user.mobile = "8861503583"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOtpLogin() {
        user.sendOtpToMobile { (isSuccessful, error) in
            XCTAssertTrue(isSuccessful)
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
