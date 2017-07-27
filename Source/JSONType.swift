//
//  Utils.swift
//  Hasura
//
//  Created by Jaison on 13/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]

public protocol JSONType: JSONConvertible, JSONParsable {
    
}

public protocol JSONConvertible {
    func toJSON() -> JSON
}

extension JSONConvertible {
    func toJSON() -> JSON {
        var json = [String: Any]()
        
        let children = Mirror(reflecting: self).children
        for child in children {
            switch child.value {
            case let value as JSONParsable:
                if let label = child.label {
                    json[label] = value
                }
                break
            case let value as NSObject:
                if let label = child.label {
                    json[label] = value
                }
                break
            default:
                break
            }
        }
        
        return json
    }
}

public protocol JSONParsable {
    
    associatedtype JSONType
        
    static func fromJSON(json: JSON) -> JSONType?
    static func fromJSON(json: JSON?) -> JSONType?
    static func fromJSON(json: [JSON]) -> [JSONType?]
    static func fromJSON(json: [JSON]?) -> [JSONType?]
}

extension JSONParsable {
    
    static func fromJSON(json: JSON?) -> JSONType? {
        guard let json = json else {
            return nil
        }
        return fromJSON(json: json)
    }
    
    static func fromJSON(json: [JSON]) -> [JSONType?] {
        return json.map(fromJSON)
    }
    
    static func fromJSON(json: [JSON]?) -> [JSONType?] {
        guard let json = json else {
            return []
        }
        return fromJSON(json: json)
    }
}
