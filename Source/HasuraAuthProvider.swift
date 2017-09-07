//
//  HasuraAuthProvider.swift
//  Hasura
//
//  Created by Jaison on 07/09/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public protocol HasuraAuthProvider {
    func getType() -> String
    func getDataObject() -> [String: Any]
    func getAsJSON() -> [String: Any]
    }

extension HasuraAuthProvider {
    
    public func getAsJSON() -> [String: Any] {
        return [
            "type": getType(),
            "data": getDataObject()
        ]
    }
    
    public static var authUrl: String? {
        get {
            return self.authUrl
        }
        set (newValue){
            self.authUrl = newValue
        }
    }
    
}
