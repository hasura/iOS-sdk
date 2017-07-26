//
//  CustomService.swift
//  Hasura
//
//  Created by Jaison on 14/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import Moya

public typealias HasuraServiceProvider = Moya.MoyaProvider
public typealias HasuraServiceEndpoint = Moya.Endpoint
public typealias DownloadType = Moya.DownloadType
public typealias UploadType = Moya.UploadType
public typealias Task = Moya.Task
public typealias DownloadDestination = Moya.DownloadDestination
public typealias MultipartFormData = Moya.MultipartFormData

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

public enum FileServiceType {
    case upload(FileServiceUploadType)
    case download(FileServiceDownloadType)
}


public protocol HasuraFileService: HasuraService {
    var type: FileServiceType { get }
}

extension FileServiceType {
    var moya: Moya.Task {
        switch self {
        case .upload(let uploadType): return uploadType.moya
        case .download(let downloadType): return downloadType.moya
        }
    }
}

extension HasuraFileService {
    
    /// The type of HTTP task to be performed.
    var task: Moya.Task {
        return self.type.moya
    }
    
}


/// Represents a type of upload task.
public enum FileServiceUploadType {
    
    /// Upload a file.
    case file(URL)
    
    /// Upload "multipart/form-data"
    case multipart([MultipartFormData])
}

extension FileServiceUploadType {
    
    var moya: Moya.Task {
        switch self {
        case .file(let url): return Moya.Task.upload(UploadType.file(url))
        case .multipart(let multipartData): return Moya.Task.upload(UploadType.multipart(multipartData))
        }
    }
    
}

extension FileServiceDownloadType {
    var moya: Moya.Task {
        switch self {
        case .request(let downloadDestination): return Moya.Task.download(DownloadType.request(downloadDestination))
        }
    }
}

/// Represents a type of download task.
public enum FileServiceDownloadType {
    
    /// Download a file to a destination.
    case request(DownloadDestination)
}


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

public protocol HasuraService: Moya.TargetType {
    var serviceName: String { get }
    var httpMethod: HTTPMethod { get }
    var paramEncoding: ParameterEncoding { get }
}

extension HasuraService {
    
    /// The target's base `URL`.
    //Ignored by HasuraServiceProvider
    var baseURL: URL {
        return URL(string: "")!
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return self.httpMethod.moya
    }
    
    
    /// The method used for parameter encoding.
    var parameterEncoding: Moya.ParameterEncoding {
        return self.paramEncoding.moya
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }
    
    /// The type of HTTP task to be performed.
    var task: Moya.Task {
        return .request
    }
    
    var validate: Bool {
        return true
    }
}

