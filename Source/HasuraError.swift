//
//  HError.swift
//  iOS-sdk
//
//  Created by Jaison on 26/06/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public enum HasuraInitError: Error {
    case noProjectOrCustomDomainSpecified
    case notInitialised
}

extension HasuraInitError {
    
    public var localizedDescription: String {
        switch self {
        case .noProjectOrCustomDomainSpecified: return "There is no project name or custom domain specified while initialising the SDK"
        case .notInitialised: return "The SDK has not been initialised. Hasura.initialise(..) must be called before using the SDK"
        }
    }
    
}

public enum HasuraError: Error {
    
    case invalidURL(url: String)
    case dataToJSON(data: Data)
    case unparsableErrorResponse(json: JSON)
    case unknown()
    
}

extension HasuraError {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let url): return "\(url) is not a valid URL"
        case .dataToJSON(let data): return "\(data.toString()) is not a valid JSON"
        case .unparsableErrorResponse(let json): return "\(json)"
        case .unknown(): return "An unknown error occured"
        }
    }
    
}
