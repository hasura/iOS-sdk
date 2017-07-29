//
//  Extensions.swift
//  Hasura
//
//  Created by Jaison on 14/07/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

extension String {
    static func +(left: String, right: Int) -> String {
        return "\(left)\(right)"
    }
}

extension Error {
    func getHasuraError() -> HasuraError {
        return HasuraError.unknown()
    }
}

extension Data {
    func toString() -> String {
        guard let string = String(data: self, encoding: .utf8) else {
            return "No JSON string for this data"
        }
        return string
    }
    
    func toJSON() throws -> JSON {
        do {
            guard let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String : Any] else {
                throw HasuraError.dataToJSON(data: self)
            }
            return json
        } catch {
            throw HasuraError.dataToJSON(data: self)
        }
    }
    
    func toHasuraErrorResponse() throws -> HasuraErrorResponse {
        do {
            let json = try self.toJSON()
            
            let code = json["code"] as? String
            let message = json["message"] as? String
            
            if code == nil && message == nil {
                throw HasuraError.unparsableErrorResponse(json: json)
            }
            
            return HasuraErrorResponse(code: code, message: message)
        } catch let error {
            throw error
        }
    }
    
}
