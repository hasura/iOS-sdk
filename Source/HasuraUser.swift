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
        HTTPManager.request(url: "/otp-login", httpMethod: .post, params: getAuthRequestBody().toJSON(), headers: nil)
    }
    
    public func confirmMobileAndLogin(completionHandler: @escaping OtpVerificationApiResponse) {
        
    }
    
    public func confirmMobile(otp: String, completionHandler: @escaping OtpVerificationApiResponse) {
        
    }
    
    public func resendOTPForMobileConfirmation(completionHandler: @escaping OtpSendingStatusResponse) {
        
    }
    
    public func resendOTPForLogin(completionHandler: @escaping OtpSendingStatusResponse) {
        
    }
    
    public func resendVerificationEmail(completionHandler: @escaping VerifyEmailSendingApiResponse) {
        
    }
    
}

extension HasuraUserImpl {
    
    public func sync(completionHandler: AuthenticatedApiResponse) {
        
    }
    
    public func changePassword(newPassword: String, completionHandler: AuthenticatedApiResponse) {
        
    }
    
    public func changeEmail(newEmail: String, ompletionHandler: AuthenticatedApiResponse) {
        
    }
    
    public func changeMobile(newMobile: String, completionHandler: AuthenticatedApiResponse) {
        
    }
    
    public func changeUsername(newUsername: String, completionHandler: AuthenticatedApiResponse) {
        
    }
    
    public func deleteAccount(completionHandler: AuthenticatedApiResponse) {
        
    }
    
    public func logout(completionHandler: @escaping AuthenticatedApiResponse) {
        HTTPManager.request(url: authUrl + "/user/logout", httpMethod: .post, headers: getAuthHeaders())
            .responseObject { (response: MessageResponse?, error: HasuraError?) in
                if let _ = response {
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

