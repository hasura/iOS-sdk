//
//  AuthResponse.swift
//  Hasura
//
//  Created by Jaison on 03/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import ObjectMapper

struct AuthResponse: Mappable {
    var authToken: String?
    var hasuraId: Int?
    var roles: [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        authToken <- map["auth_token"]
        hasuraId <- map["hasura_id"]
        roles <- map["hasura_roles"]
    }

}
