//
//  AnonymousUserApis.swift
//  Hasura
//
//  Created by Jaison on 03/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public typealias SignUpApiResponse = (_ isSuccessful: Bool, _ isPendingVerification: Bool, _ error: HasuraError?) -> Void
public typealias LoginApiResponse = (_ isSuccessful: Bool, _ error: HasuraError?) -> Void
public typealias OtpSendingStatusResponse = (_ isSentSuccessfully: Bool, _ error: HasuraError?) -> Void
public typealias OtpVerificationApiResponse = (_ isConfirmed: Bool, _ error: HasuraError?) -> Void
public typealias VerifyEmailSendingApiResponse = (_ isSentSuccessfully: Bool, _ error: HasuraError?) -> Void

public enum HasuraSocialLoginType: String {
    case facebook = "facebook"
    case google = "google"
    case linkedin = "linkedin"
    case github = "github"
    
    func getUrl(token: String) -> String {
        let url = "/" + rawValue + "/authenticate?"
        switch self {
        case .google:
            return url + "id_token=" + token
        default:
            return url + "access_token=" + token
        }
    }
}

public protocol AnonymousUserApi {
    
    var authUrl: String { get }
    
    func socialLogin(loginType: HasuraSocialLoginType, token: String, completionHandler: @escaping LoginApiResponse)
    
    func signUp(completionHandler: @escaping SignUpApiResponse)
    func otpSignUp(completionHandler: @escaping SignUpApiResponse)
    
    func login(completionHandler: @escaping LoginApiResponse)
    func otpLogin(otp: String, completionHandler: @escaping LoginApiResponse)
    func sendOtpToMobile(completionHandler: @escaping OtpSendingStatusResponse)
    func confirmMobileAndLogin(otp: String, completionHandler: @escaping LoginApiResponse)
    
    func confirmMobile(otp: String, completionHandler: @escaping OtpVerificationApiResponse)
    
    func resendOTPForMobileConfirmation(completionHandler: @escaping OtpSendingStatusResponse)
    func resendOTPForLogin(completionHandler: @escaping OtpSendingStatusResponse)
    func resendVerificationEmail(completionHandler: @escaping VerifyEmailSendingApiResponse)
    
}
