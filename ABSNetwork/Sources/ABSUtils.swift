//
//  ABSUtils.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation

open class ABSUtils {

    open static func toData(from anyObject: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: anyObject, options: .prettyPrinted)
        } catch {
            ABSLogger.log("any to json string error, \(error.localizedDescription)")
        }
        return nil
    }
    
    open static func string2Dict(from string: String) -> [String: Any]? {
        if let data = string.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                ABSLogger.log("json string to dict error, \(error.localizedDescription)")
            }
        }
        return nil
    }
    
}
