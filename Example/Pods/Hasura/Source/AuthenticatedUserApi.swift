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
    func changePassword(newPassword: String, completionHandler: @escaping AuthenticatedApiResponse)
    func changeEmail(newEmail: String, completionHandler: @escaping AuthenticatedApiResponse)
    func changeMobile(newMobile: String, completionHandler: @escaping AuthenticatedApiResponse)
    func changeUsername(newUsername: String, completionHandler: @escaping AuthenticatedApiResponse)
    func deleteAccount(password: String, completionHandler: @escaping AuthenticatedApiResponse)
    func logout(completionHandler: @escaping AuthenticatedApiResponse)
    
}


