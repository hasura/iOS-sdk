//
//  AnonymousApis.swift
//  Hasura
//
//  Created by Jaison on 13/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

enum AuthService {
    case login(request: AuthRequest)
}

extension AuthService: HasuraService {
    
    ///Service Name
    var serviceName: String {
        return "auth"
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .login(_):
            return "/login"
        }
    }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod {
        switch self {
        case .login(_):
            return .post
        }
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        switch self {
        case .login(let request):
            return request.toJSON()
        }
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return .json
    }
    
    /// The type of HTTP task to be performed.
    var type: RequestType {
        return .normal
    }
}
