//
//  CustomService.swift
//  Example
//
//  Created by Jaison on 14/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import Hasura

enum CustomService {
    case someApi()
}

extension CustomService: HasuraService {
    
    var serviceName: String {
        return "customService"
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        return "/path"
    }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod {
        return .post
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return [
            "username" : "jaison",
            "password" : "password"
        ]
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        let data: [String: Any] =  [
            "hasura_id": 1,
            "auth_token": "qeqweqwewqeqwe",
            "hasura_roles": [
                "user"
            ]
        ]
        return NSKeyedArchiver.archivedData(withRootObject: data)
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        return .request
    }
    
    
}

