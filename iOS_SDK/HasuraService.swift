//
//  HasuraService.swift
//  Hasura
//
//  Created by Jaison on 13/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

//Parameter Encoding
public enum ParameterEncoding {
    case json
    case url
    case propertyList
}


//HTTP methods
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}


public enum RequestType {
    case normal
}

public protocol HasuraService {
    
    var serviceName: String { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? { get }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding { get }
    
    /// The type of HTTP task to be performed.
    var type: RequestType { get }
    
}
