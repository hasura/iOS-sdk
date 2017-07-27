//
//  AuthRequest.swift
//  Hasura
//
//  Created by Jaison on 28/06/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

struct AuthRequest: JSONConvertible {
    
    var username: String?
    var password: String?
    var mobile: String?
    var email: String?
    
    init(username: String?, password: String?, mobile: String?, email: String?) {
        self.username = username
        self.password = password
        self.email = email
        self.mobile = mobile
    }
    
}
