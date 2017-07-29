//
//  HasuraUser.swift
//  iOS-sdk
//
//  Created by Jaison on 13/06/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public protocol AuthStatusProvider {
    var isLoggedIn: Bool { get }
}

public protocol HasuraUser: AuthStatusProvider, AnonymousUserApi, AuthenticatedUserApi {
    var id: Int? { get }
    var email: String? { get set }
    var mobile: String? { get set }
    var username: String? { get set }
    var password: String? { get set }
    var roles: [String]? { get }
    var authToken: String? { get }
}

public class HasuraUserImpl: HasuraUser, AuthHeaderProvider {
    
    public var authUrl: String
    public var id: Int?
    public var email: String?
    public var mobile: String?
    public var username: String?
    public var password: String?
    public var roles: [String]?
    public var authToken: String?
    
    init(authUrl: String, shouldPopulate: Bool = false) {
        self.authUrl = authUrl
        if shouldPopulate {
            populate()
        }
    }
    
    internal func getAuthHeaders(role: String? = nil) -> HTTPHeaders? {
        var authHeader: HTTPHeaders?
        if let authToken = authToken {
            authHeader = HTTPHeaders()
            authHeader?["X-Hasura-Role"] = "user"
            authHeader?["Authorization"] = "Bearer " + authToken
        }
        return authHeader
    }
    
    fileprivate func clearAllData() {
        id = nil
        email = nil
        mobile = nil
        username = nil
        password = nil
        roles = nil
        authToken = nil
    }
    
}

extension HasuraUserImpl {
    
    public var isLoggedIn: Bool {
        return authToken != nil
    }
    
    func getAuthRequestBody() -> AuthRequest {
        return AuthRequest(username: username, password: password, mobile: mobile, email: email)
    }
}

extension HasuraUserImpl {
    
    private func performAuthRequest(url: String, completionHandler: @escaping LoginApiResponse) {
        HTTPManager.request(url: url, httpMethod: .post, params: getAuthRequestBody().toJSON(), headers: nil)
            .responseObject { (response: AuthResponse?, error) in
                if let response = response {
                    self.id = response.hasuraId
                    self.authToken = response.authToken
                    self.roles = response.roles
                    self.save()
                    completionHandler(true, nil)
                } else if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(false, HasuraError.unknown())
                }
        }
    }
    
    public func socialLogin(loginType: HasuraSocialLoginType, token: String, completionHandler: @escaping LoginApiResponse) {
        performAuthRequest(url: loginType.getUrl(token: token), completionHandler: completionHandler)
    }
    
    
    public func login(completionHandler: @escaping LoginApiResponse) {
        performAuthRequest(url: authUrl + "/login", completionHandler: completionHandler)
    }
    
    public func otpLogin(otp: String, completionHandler: @escaping LoginApiResponse) {
        performAuthRequest(url: authUrl + "/otp-login", completionHandler: completionHandler)
    }
    
    
    private func performSignUpRequest(url: String, completionHandler: @escaping SignUpApiResponse) {
        HTTPManager.request(url: url, httpMethod: .post, params: getAuthRequestBody().toJSON(), headers: nil)
            .responseObject { (response: AuthResponse?, error) in
                if let response = response {
                    self.id = response.hasuraId
                    self.authToken = response.authToken
                    self.roles = response.roles
                    self.save()
                    completionHandler(true, response.authToken == nil, nil)
                } else if let error = error {
                    completionHandler(false, false, error)
                } else {
                    completionHandler(false, false, HasuraError.unknown())
                }
        }
    }
    
    
    
    public func signUp(completionHandler: @escaping SignUpApiResponse) {
        performSignUpRequest(url: authUrl + "/signup", completionHandler: completionHandler)
    }
    
    public func otpSignUp(completionHandler: @escaping SignUpApiResponse) {
        performSignUpRequest(url: authUrl + "/otp-signup", completionHandler: completionHandler)
    }
    
    public func sendOtpToMobile(completionHandler: @escaping OtpSendingStatusResponse) {
        HTTPManager.request(url: authUrl + "/otp-login", httpMethod: .post, params: getAuthRequestBody().toJSON(), headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if let _ = response {
                    completionHandler(true, nil)
                } else if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(false, HasuraError.unknown())
                }
        }
    }
    
    public func confirmMobileAndLogin(otp: String, completionHandler: @escaping LoginApiResponse) {
        confirmMobile(otp: otp) { (isSentSuccessfully, error) in
            if isSentSuccessfully {
                self.login(completionHandler: { (isSuccessful, error) in
                    completionHandler(isSuccessful, error)
                })
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    public func confirmMobile(otp: String, completionHandler: @escaping OtpVerificationApiResponse) {
        HTTPManager.request(url: "mobile/confirm", httpMethod: .post, params: ConfirmMobileRequest(mobile: mobile!, otp: otp).toJSON(), headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if response != nil {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
    public func resendOTPForMobileConfirmation(completionHandler: @escaping OtpSendingStatusResponse) {
        HTTPManager.request(url: "mobile/resend-otp", httpMethod: .post, params: ["mobile": mobile!], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if response != nil {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
    public func resendOTPForLogin(completionHandler: @escaping OtpSendingStatusResponse) {
        sendOtpToMobile(completionHandler: completionHandler)
    }
    
    public func resendVerificationEmail(completionHandler: @escaping VerifyEmailSendingApiResponse) {
        HTTPManager.request(url: "email/resend-verify", httpMethod: .post, params: ["email" : email!], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if response != nil {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
}

extension HasuraUserImpl {
    
    public func sync(completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: "user/account/info", httpMethod: .get, params: nil, headers: nil)
            .responseObject { (response: AuthResponse?, error) in
                if let response = response {
                    self.id = response.hasuraId
                    self.authToken = response.authToken
                    self.roles = response.roles
                    self.save()
                    completionHandler(true, nil)
                } else if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(false, HasuraError.unknown())
                }
        }
    }
    
    public func changePassword(newPassword: String, completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: "user/password/change", httpMethod: .post, params: ["password" : password!, "new_password" : newPassword], headers: nil)
            .responseObject { (response: ChangePasswordResponse?, error) in
                if let response = response {
                    self.authToken = response.authToken!
                    self.password = newPassword
                    self.save()
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
    public func changeEmail(newEmail: String, completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: "user/email/change", httpMethod: .post, params: ["email" : newEmail], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if response != nil {
                    self.email = newEmail
                    self.save()
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
    public func changeMobile(newMobile: String, completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: "user/mobile/change", httpMethod: .post, params: ["mobile" : newMobile], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if response != nil {
                    self.mobile = newMobile
                    self.save()
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
    public func changeUsername(newUsername: String, completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: "user/account/change-username", httpMethod: .post, params: ["username" : newUsername], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if response != nil {
                    self.username = newUsername
                    self.save()
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
    public func deleteAccount(password: String, completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: "user/account/delete", httpMethod: .post, params: ["password" : password], headers: nil)
            .responseObject { (response: MessageResponse?, error) in
                if response != nil {
                    self.clearAllData()
                    self.save()
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, error != nil ? error! : HasuraError.unknown())
                }
        }
    }
    
    public func logout(completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: authUrl + "/user/logout", httpMethod: .post, headers: getAuthHeaders())
            .responseObject { (response: MessageResponse?, error: HasuraError?) in
                if response != nil {
                    self.clearAllData()
                    self.save()
                    completionHandler(true, nil)
                } else if let error = error {
                    completionHandler(false, error)
                } else {
                    completionHandler(false, HasuraError.unknown())
                }
        }
    }
}

