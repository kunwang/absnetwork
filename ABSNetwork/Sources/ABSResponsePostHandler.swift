//
//  ABSResponsePostHandler.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation

public protocol ABSResponsePostHandler: class {
    
    // if return ture, the next post handlers will continue executing
    // if return false, the next post handlers will not continue executing and request will return
    func process(_ requestRef: ABSRequestRef, _ manager: ABSRequestSessionManager, _ request: ABSRequest, _ response: ABSResponse, _ handler: ABSCompleteHandlerDelegate?) -> Bool
    
}

public class ABSResponsePostRetryHandler: ABSResponsePostHandler {
    
    private init() {}
    
    public static let shared = ABSResponsePostRetryHandler()
    
    public func process(_ requestRef: ABSRequestRef, _ manager: ABSRequestSessionManager, _ request: ABSRequest, _ response: ABSResponse, _ handler: ABSCompleteHandlerDelegate?) -> Bool {
        if response.error is ABSServerResponseError && request.retryTimes > 0 {
            request.retryTimes(request.retryTimes - 1)
            manager.requestExecute(requestRef, request, handler)
            return false
        }
        return true
    }
    
}
