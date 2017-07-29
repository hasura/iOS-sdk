//
//  MessageResponse.swift
//  Hasura
//
//  Created by Jaison on 03/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import ObjectMapper

struct MessageResponse: Mappable {
    
    var message: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
    }
    
}
