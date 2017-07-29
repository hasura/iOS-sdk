//
//  ChangePasswordResponse.swift
//  Hasura
//
//  Created by Jaison on 27/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChangePasswordResponse: Mappable {
    
    var message: String?
    var authToken: String?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        authToken <- map["auth_token"]
    }
    
}
