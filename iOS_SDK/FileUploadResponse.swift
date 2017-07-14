//
//  FileUploadResponse.swift
//  Hasura
//
//  Created by Jaison on 07/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import ObjectMapper

enum FileStatus: String {
    case uploaded = "uploaded"
}
//
//public struct FileUploadResponse: JSONParsable {
//    
//    var id: String?
//    var contentType: String?
//    var status: FileStatus?
//    var size: Double?
//    var userId: Int?
//    var userRole: String?
//    var createdAt: Date?
//    
//    
//    public init?(map: Map) {
//        
//    }
////    
//    mutating public func mapping(map: Map) {
//        id <- map["file_id"]
//        contentType <- map["content-type"]
//        status <- map["file_status"]
//        size <- map["file_size"]
//        userId <- map["user_id"]
//        userRole <- map["user_role"]
//        createdAt <- map["created_at"]
//    }
//    
//    
//    static let dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale.current
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//        return dateFormatter
//    }()
//    
//    let dataTransform = CustomJsonTransform<Date, String>(
//        fromJSON: { (dateString: String?) -> Date? in
//            if let dateString = dateString {
//                return dateFormatter.date(from: dateString)
//            }
//            return nil
//    }) { (date: Date?) -> String? in
//        if let date = date {
//            return dateFormatter.string(from: date)
//        }
//        return nil
//    }
//    
//}
