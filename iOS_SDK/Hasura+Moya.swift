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


protocol MoyaHTTPMethod {
    var moya: Moya.Method { get }
}

extension HTTPMethod: MoyaHTTPMethod {
    
    var moya: Moya.Method {
        switch self {
        case .options: return Moya.Method.options
        case .get     : return Moya.Method.get
        case .head    : return Moya.Method.head
        case .post    : return Moya.Method.post
        case .put     : return Moya.Method.put
        case .patch   : return Moya.Method.patch
        case .delete  : return Moya.Method.delete
        case .trace   : return Moya.Method.trace
        case .connect : return Moya.Method.connect
        }
    }
    
}

protocol MoyaParamaterEncoding {
    var moya: Moya.ParameterEncoding { get }
}

extension ParameterEncoding: MoyaParamaterEncoding {
    var moya: Moya.ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        case .propertyList: return PropertyListEncoding.default
        case .url: return URLEncoding.default
        }
    }
    
}

protocol MoyaTask {
    var moya: Moya.Task { get }
}

extension RequestType: MoyaTask {
    var moya: Moya.Task {
        switch self {
        case .normal: return Moya.Task.request
        }
    }
}


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

