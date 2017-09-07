//
//  UsernameAuthProvider.swift
//  Hasura
//
//  Created by Jaison on 07/09/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public class UsernameAuthProvider: HasuraAuthProvider {

    var username: String!
    var password: String!
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    public func getType() -> String {
        return "username"
    }
    
    public func getDataObject() -> [String : Any] {
        return [            
            "username": username,
            "password": password
        ]
    }
}
