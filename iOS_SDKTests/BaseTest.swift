//
//  BaseTest.swift
//  Hasura
//
//  Created by Jaison on 28/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import XCTest
import Hasura

class BaseTest: XCTestCase {
    
    var user: HasuraUser!
    var client: HasuraClient!
    
    override func setUp() {
        super.setUp()
        do {
            try Hasura.initialise(config: ProjectConfig(projectName: "hello70"), enableLogs: true)
            client = Hasura.getClient()
            user = client.currentUser
        } catch (let error) {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
