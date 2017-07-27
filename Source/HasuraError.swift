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
    case noProjectConfigProvided
    case notInitialised
}

public enum HasuraError: Error {
    
    case invalidURL(url: String)
    case dataToJSON(data: Data)
    case unknown()
    
}
