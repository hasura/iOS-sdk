//
//  Hasura.swift
//  Hasura
//
//  Created by Jaison on 03/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

struct Defaults {
    static let IS_ENABLED_OVER_HTTP = false
    static let DEFAULT_ROLE  = "user"
    static let API_VERSION = 1
    static let SUB_DOMAIN = ".hasura-app.io"
}

public struct ProjectConfig {
    
    var httpProtocol: String
    var baseDomain: String
    var version: String
    var defaultRole: String
    
    var authUrl: String {
        get {
            return httpProtocol + "://auth." + baseDomain
        }
    }
    
    private var dataUrl: String {
        get {
            return httpProtocol + "://data." + baseDomain
        }
    }
    
    var dataQueryUrl: String {
        get {
            return dataUrl + "/" + version + "/" + "query"
        }
    }
    
    var queryTemplateUrl: String {
        get {
            return dataUrl + "/" + version + "/" + "template/"
        }
    }
    
    var filestoreUrl: String {
        get {
            return httpProtocol + "://filestore." + baseDomain + "/" + version + "/file/"
        }
    }
    
    public func getCustomServiceBaseURL(serviceName: String) -> String {
        return httpProtocol + "://" + serviceName + "." + baseDomain
    }
    
    public init(projectName: String?,
          customSubDomain: String? = nil,
          isEnabledOverHttp: Bool =  Defaults.IS_ENABLED_OVER_HTTP,
          defaultRole: String = Defaults.DEFAULT_ROLE,
          apiVersion: Int = Defaults.API_VERSION
        ) throws {
        
        self.httpProtocol = isEnabledOverHttp ? "http" : "https"
        if let projectName = projectName {
            self.baseDomain = projectName + ".hasura-app.io"
        } else if let customBaseDomain = customSubDomain {
            self.baseDomain  = customBaseDomain
        } else {
            throw HasuraInitError.noProjectOrCustomDomainSpecified
        }
        self.version = "v" + apiVersion
        self.defaultRole = defaultRole
    }
    
    
}

public struct Hasura {
    
    static var `default`: Hasura?
    
    var projectConfig: ProjectConfig
    var shouldEnableLogs: Bool
    private var client: HasuraClient?
    
    public static func getClient() throws -> HasuraClient {
        guard let instance = `default` else {
            throw HasuraInitError.notInitialised
        }
        guard let client = instance.client else {
            throw HasuraInitError.notInitialised
        }
        return client
    }
    
    @discardableResult
    public static func initialise(config: ProjectConfig, enableLogs:Bool = false) -> Hasura {
        `default` =  Hasura(projectConfig: config, shouldEnableLogs: enableLogs)
        return `default`!
    }
    
    fileprivate init(projectConfig: ProjectConfig, shouldEnableLogs: Bool) {
        self.projectConfig = projectConfig
        self.shouldEnableLogs = shouldEnableLogs
        self.client = HasuraClientImpl(projectConfig: projectConfig, shouldEnableLogs: shouldEnableLogs)
    }
    
}
