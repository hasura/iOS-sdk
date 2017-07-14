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
    
    func sync(completionHandler: AuthenticatedApiResponse)
    func changePassword(newPassword: String, completionHandler: AuthenticatedApiResponse)
    func changeEmail(newEmail: String, ompletionHandler: AuthenticatedApiResponse)
    func changeMobile(newMobile: String, completionHandler: AuthenticatedApiResponse)
    func changeUsername(newUsername: String, completionHandler: AuthenticatedApiResponse)
    func deleteAccount(completionHandler: AuthenticatedApiResponse)
    func logout(completionHandler: @escaping AuthenticatedApiResponse)
    
}


