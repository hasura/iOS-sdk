//
//  File.swift
//  Hasura
//
//  Created by Jaison on 07/09/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public class EmailAuthProvider: HasuraAuthProvider {

    var email: String!
    var password: String!
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    public func getType() -> String {
        return "email"
    }
    
    public func getDataObject() -> [String : Any] {
        return [
            "email": email,
            "password": password
        ]
    }
}

extension EmailAuthProvider {
    public static func resendVerificationEmail(email: String, completionHandler: @escaping (_ emailSentSuccessfully: Bool, _ error: HasuraError?) -> Void) {
        let params: JSON = ["email": email]
        let url = authUrl! + "/providers/email/resend"
        HTTPManager.request(url: url, httpMethod: .post, params: params, headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(true, nil)
                }
        }
    }
    
    public static func resetPassword(email: String, completionHandler: @escaping (_ resetEmailSentSuccessfully: Bool, _ error: HasuraError?) -> Void) {
        HTTPManager.request(url: authUrl! + "providers/email/forgot", httpMethod: .post, params: ["email": email], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(true, nil)
                }
        }
    }
}
