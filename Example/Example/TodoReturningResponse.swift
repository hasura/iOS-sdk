//
//  TodoReturningResponse.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 19/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import ObjectMapper

class TodoReturningResponse: Mappable {
    
    var affectedRows: Int?
    var returning: [TodoRecord]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        affectedRows <- map["affected_rows"]
        returning <- map["returning"]
    }
}
