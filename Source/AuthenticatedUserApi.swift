//
//  AuthenticatedUserApi.swift
//  Hasura
//
//  Created by Jaison on 03/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public typealias AuthenticatedApiResponse = (Bool, HasuraError?) -> Void

public protocol AuthenticatedUserApi {
    
    func sync(completionHandler: @escaping AuthenticatedApiResponse)
    func logout(completionHandler: @escaping AuthenticatedApiResponse)
    
}


