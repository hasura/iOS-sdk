//
//  TodoRecord.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import ObjectMapper

class TodoRecord: Mappable {
    
    var id: Int!
    var title: String!
    var userId: Int!
    var completed: Bool!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        userId <- map["user_id"]
        completed <- map["completed"]
    }
}
