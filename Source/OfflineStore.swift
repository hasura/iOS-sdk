//
//  HasuraSessionStore.swift
//  Hasura
//
//  Created by Jaison on 05/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

protocol OfflineStore {
    
    var defaults: UserDefaults { get }
    
    func save()
    mutating func populate()
}

extension OfflineStore {
    
    public var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
}

extension HasuraUserImpl: OfflineStore {
    
    struct StoreKeys {
        static let HASURA_ID = "hasuraIdKey"
        static let EMAIL = "emailKey"
        static let MOBILE = "mobileKey"
        static let USERNAME = "usernameKey"
        static let PASSWORD = "passwordKey"
        static let ROLES = "rolesKey"
        static let AUTH_TOKEN = "authTokenKey"
    }
    
    public func save() {
        defaults.set(id, forKey: StoreKeys.HASURA_ID)
        defaults.set(email, forKey: StoreKeys.EMAIL)
        defaults.set(mobile, forKey: StoreKeys.MOBILE)
        defaults.set(username, forKey: StoreKeys.USERNAME)
        defaults.set(password, forKey: StoreKeys.PASSWORD)
        defaults.set(roles, forKey: StoreKeys.ROLES)
        defaults.set(authToken, forKey: StoreKeys.AUTH_TOKEN)
    }
    
    public func populate() {
        let userId = defaults.integer(forKey: StoreKeys.HASURA_ID)
        guard
            let authToken = defaults.string(forKey: StoreKeys.AUTH_TOKEN),
            userId != 0,
            let roles = defaults.array(forKey: StoreKeys.ROLES) as? [String] else {
            return
        }
        
        self.authToken = authToken
        self.id = userId
        self.roles = roles

        self.email = defaults.string(forKey: StoreKeys.EMAIL)
        self.mobile = defaults.string(forKey: StoreKeys.MOBILE)
        self.username = defaults.string(forKey: StoreKeys.USERNAME)
        self.password = defaults.string(forKey: StoreKeys.PASSWORD)
        
    }
    
}





















