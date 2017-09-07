//
//  AuthResponse.swift
//  Hasura
//
//  Created by Jaison on 03/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import ObjectMapper

public struct AuthResponse: Mappable {
    var authToken: String?
    var hasuraId: Int?
    var roles: [String]?
    var email: String?
    var mobile: String?
    var username: String?
    var newUser: Bool?
    var accessToken: String?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        authToken <- map["auth_token"]
        hasuraId <- map["hasura_id"]
        roles <- map["hasura_roles"]
        email <- map["email"]
        mobile <- map["mobile"]
        username <- map["username"]
        newUser <- map["new_user"]
        accessToken <- map["access_token"]
    }

}
