//
//  ErrorResponse.swift
//  Hasura
//
//  Created by Jaison on 27/06/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public struct HasuraErrorResponse {
    
    var code: String?
    var message: String?
    
    init(code: String?, message: String?) {
        self.code = code
        self.message = message
    }
    
}
