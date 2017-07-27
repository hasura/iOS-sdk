//
//  HasuraClieny.swift
//  Hasura
//
//  Created by Jaison on 03/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public protocol HasuraFileStoreService {
    func uploadFile(file: Data, mimeType: String) -> HasuraUploadFileRequest
    func downloadFile(fileId: String) -> HasuraDownloadFileRequest
}

internal protocol AuthHeaderProvider {
    func getAuthHeaders(role: String?) -> HTTPHeaders?
}

extension AuthHeaderProvider {
    func getAuthHeaders(role: String? = nil) -> HTTPHeaders? {
        return getAuthHeaders(role: role)
    }
}

public protocol HasuraClient {
    
    var currentUser: HasuraUser { get }
    
    @discardableResult
    func useDataService(role: String?, params: JSON) -> HasuraDataRequest
    
    @discardableResult
    func useQueryTemplateService(role: String?, templateName: String, params: JSON?) -> HasuraDataRequest
    
    @discardableResult
    func useFileservice(role: String?) -> HasuraFileStoreService
}

extension HasuraClient {
    
    @discardableResult
    public func useDataService(role: String? = nil, params: JSON) -> HasuraDataRequest {
        return useDataService(role: role, params: params)
    }
    
    @discardableResult
    func useQueryTemplateService(role: String? = nil, templateName: String, params: JSON?) -> HasuraDataRequest {
        return useQueryTemplateService(role: role, templateName: templateName, params: params)
    }
    
    @discardableResult
    func useFileservice(role: String? = nil) -> HasuraFileStoreService{
        return useFileservice(role: role)    
    }
    
}

class HasuraClientImpl: HasuraClient, AuthHeaderProvider {
    
    var shouldEnableLogs: Bool
    var projectConfig: ProjectConfig
    public var currentUser: HasuraUser
    
    init(projectConfig: ProjectConfig, shouldEnableLogs: Bool) {
        self.shouldEnableLogs = shouldEnableLogs
        self.projectConfig = projectConfig
        self.currentUser = HasuraUserImpl(authUrl: projectConfig.authUrl, shouldPopulate: true)
    }
    
    internal func getAuthHeaders(role: String? = nil) -> HTTPHeaders? {
        var authHeader: HTTPHeaders?
        
        let role = role != nil ? role! : projectConfig.defaultRole
        if role == "anonymous" {
            return authHeader
        }
        
        authHeader = HTTPHeaders()
        authHeader?["X-Hasura-Role"] = role
        if let authToken = currentUser.authToken {
            authHeader?["Authorization"] = "Bearer " + authToken
        }
        return authHeader
    }
    
    @discardableResult
    func useDataService(role: String? = nil, params: JSON) ->  HasuraDataRequest {
        return HTTPManager.request(url: projectConfig.dataQueryUrl, httpMethod: .post, params: params, headers: getAuthHeaders(role: role))
    }
    
    @discardableResult
    func useQueryTemplateService(role: String?, templateName: String, params: JSON) -> HasuraDataRequest {
        return HTTPManager.request(url: projectConfig.queryTemplateUrl + templateName, httpMethod: .post, params: params, headers: getAuthHeaders(role: role))
    }
    
    @discardableResult
    func useFileservice(role: String?) -> HasuraFileStoreService {
        return FileStoreServiceImpl(role: role != nil ? role! : projectConfig.defaultRole, headers: getAuthHeaders(role: role), filestoreUrl: projectConfig.filestoreUrl)
    }
    
    class FileStoreServiceImpl: HasuraFileStoreService {
        
        var role: String
        var headers: HTTPHeaders?
        var filestoreUrl: String
        
        init(role: String, headers: HTTPHeaders?, filestoreUrl: String) {
            self.role = role
            self.headers = headers
            self.filestoreUrl = filestoreUrl
        
        }
        
        func uploadFile(file: Data, mimeType: String) -> HasuraUploadFileRequest {
            
            if headers == nil {
                headers = HTTPHeaders()
            }
            
            headers!["Content-Type"] = mimeType
            
            return HTTPManager.upload(url: filestoreUrl + UUID().uuidString, data: file, headers: headers)
        }
        
        func downloadFile(fileId: String) -> HasuraDownloadFileRequest {
            return HTTPManager.download(url: filestoreUrl + fileId, headers: headers)
        }
    }
    
}
