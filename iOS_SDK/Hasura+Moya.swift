//
//  Hasura+Moya.swift
//  Hasura
//
//  Created by Jaison on 13/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import Moya

public typealias ServiceType = Moya.TargetType
public typealias Task = Moya.Task

public typealias HTTPHeaders = [String: String]

public typealias Encoding = Moya.ParameterEncoding
public typealias JSONEncoding = Moya.JSONEncoding
public typealias URLEncoding = Moya.URLEncoding
public typealias PropertyListEncoding = Moya.PropertyListEncoding

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

protocol ServiceBaseUrlCreator {
    func getBaseURL(serviceName: String) -> URL
}

struct ServiceTypeImpl: ServiceType {

    let hasuraService: HasuraService
    let baseUrlCreator: ServiceBaseUrlCreator
    
    /// The target's base `URL`.
    var baseURL: URL {
        return baseUrlCreator.getBaseURL(serviceName: hasuraService.serviceName)
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        return hasuraService.path
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return hasuraService.method.moya
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return hasuraService.parameters
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: Moya.ParameterEncoding {
        return hasuraService.parameterEncoding.moya
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {        
        return hasuraService.type.moya
    }

}

extension HasuraService {
    
    func toServiceType(baseUrlCreator: ServiceBaseUrlCreator) -> ServiceType {
        return ServiceTypeImpl(hasuraService: self, baseUrlCreator: baseUrlCreator)
    }
}
