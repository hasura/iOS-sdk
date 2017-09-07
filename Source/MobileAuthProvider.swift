//
//  File.swift
//  Hasura
//
//  Created by Jaison on 07/09/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public class MobileAuthProvider: HasuraAuthProvider {
        
    var mobile: String!
    var otp: String!
    
    public init(mobile: String, otp: String) {
        self.mobile = mobile
        self.otp = otp
    }
    
    public func getType() -> String {
        return "mobile"
    }
    
    public func getDataObject() -> [String: Any] {
        return [
            "mobile": mobile,
            "otp": otp
        ]
    }
}

extension MobileAuthProvider {
    
    public static func sendOtp(mobile: String, completionHandler: @escaping (_ otpSentSuccessfully: Bool, _ error: HasuraError?) -> Void) {
        HTTPManager.request(url: authUrl! + "providers/mobile/send-otp", httpMethod: .post, params: ["mobile": mobile], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(true, nil)
                }
        }
    }
    
    public static func reSendOtp(mobile: String, completionHandler: @escaping (_ otpSentSuccessfully: Bool, _ error: HasuraError?) -> Void) {
        HTTPManager.request(url: authUrl! + "providers/mobile/resend-otp", httpMethod: .post, params: ["mobile": mobile], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(true, nil)
                }
        }
    }
    
}
