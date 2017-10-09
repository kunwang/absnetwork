//
//  ABSRequestPreHandler.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation

public protocol ABSRequestPreHandler: class {
    
    // if return ture, the next pre handlers will continue executing
    // if return false, the next pre handlers will not continue executing and request will return
    func process(_ manager: ABSRequestSessionManager, _ request: ABSRequest) -> Bool
    
}

public class ABSRequestPreCommonHeaderHandler: ABSRequestPreHandler {
    
    public var userAgent = "ABSNetwork"
    
    private init() {}
    
    public static let shared = ABSRequestPreCommonHeaderHandler()
    
    public func process(_ manager: ABSRequestManager, _ request: ABSRequest) -> Bool {
        var headers = [String: String]()
        for (key, value) in request.headers {
            headers[key] = value
        }
        // upload content type
        if request.isUpload() {
            headers["Content-Type"] = "application/octet-stream"
        }
        // client agent
        headers["User-Agent"] = userAgent
        // Accept-Language
        if Locale.preferredLanguages.count > 0 {
            let preferredLanguage = Locale.preferredLanguages[0]
            headers["Accept-Language"] = preferredLanguage
        }
        request.headers(headers)
        return true
    }
    
}
