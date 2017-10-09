//
//  ABSRequestor+Generic.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation
import ObjectMapper

extension ABSRequestor {
    
    @discardableResult
    public func handler<T: Mappable>(success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil, fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestor {
        let genericHandler = ABSGenericBaseCompleteHandler(success: success, fail: fail)
        self._handler = ABSBaseCompleteHandler(success:{(request, response) in genericHandler.success(request, response)}, fail:{(request, response) in genericHandler.fail(request, response)})
        return self
    }
    
    @discardableResult
    public func handler<Delegate: ABSGenericCompleteHandlerDelegate>(delegate: Delegate) -> ABSRequestor {
        let genericHandler = ABSAnyGenericCompleteHandler<Delegate>(delegate: delegate)
        self._handler = ABSBaseCompleteHandler(success:{(request, response) in genericHandler.success(request, response)}, fail:{(request, response) in genericHandler.fail(request, response)})
        return self
    }
    
    @discardableResult
    public func handler<T: Mappable>(success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil, fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestor {
        let genericHandler = ABSGenericArrayBaseCompleteHandler(success: success, fail: fail)
        self._handler = ABSBaseCompleteHandler(success:{(request, response) in genericHandler.success(request, response)}, fail:{(request, response) in genericHandler.fail(request, response)})
        return self
    }
    
    @discardableResult
    public func handler<Delegate: ABSGenericArrayCompleteHandlerDelegate>(delegate: Delegate) -> ABSRequestor {
        let genericHandler = ABSAnyGenericArrayCompleteHandler<Delegate>(delegate: delegate)
        self._handler = ABSBaseCompleteHandler(success:{(request, response) in genericHandler.success(request, response)}, fail:{(request, response) in genericHandler.fail(request, response)})
        return self
    }
    
}
