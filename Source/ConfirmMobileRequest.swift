//
//  ConfirmMobileRequest.swift
//  Hasura
//
//  Created by Jaison on 27/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

struct ConfirmMobileRequest: JSONConvertible {
    var mobile: String
    var otp: String
}
