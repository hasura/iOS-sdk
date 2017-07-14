//
//  CustomService.swift
//  Hasura
//
//  Created by Jaison on 14/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import Moya

//public typealias HasuraService =  Moya.TargetType
public typealias HasuraServiceProvider = Moya.MoyaProvider
public typealias HasuraServiceEndpoint = Moya.Endpoint

public typealias HTTPMethod = Moya.Method
public typealias ParameterEncoding = Moya.ParameterEncoding
public typealias JSONEncoding = Moya.JSONEncoding
public typealias URLEncoding = Moya.URLEncoding
public typealias PropertyListEncoding = Moya.PropertyListEncoding
public typealias DownloadType = Moya.DownloadType
public typealias UploadType = Moya.UploadType
public typealias Task = Moya.Task


protocol HasuraService: Moya.TargetType {
    var serviceName: String { get }
}

extension HasuraService {
    
    /// The target's base `URL`.
    //Ignored by HasuraServiceProvider
    var baseURL: URL {
        return URL(string: "")!
    }

    /// The HTTP method used in the request.
    var method: Moya.Method { get }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? { get }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding { get }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { get }
    
    /// The type of HTTP task to be performed.
    var task: Task { get }

    
}

