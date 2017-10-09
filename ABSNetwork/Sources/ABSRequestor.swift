//
//  ABSRequestor.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation
import Alamofire

open class ABSRequestor {
    
    var _request: ABSRequest
    var _handler: ABSBaseCompleteHandler?
    var _requestRef: ABSRequestRef?
    var _requestProcessFinished = false
    var _requestSuccessed = false
    // for multi requests join
    public var requestProcessFinish: (()->())?
    public var delegate: ABSCompleteHandlerDelegate? {
        get {
            return _handler?.delegate
        }
        set {
            if let theHandler = self._handler {
                theHandler.delegate = newValue
            } else {
                self._handler = ABSBaseCompleteHandler(delegate: newValue)
            }
        }
    }
    
    public init(_ request: ABSRequest) {
        self._request = request
    }
    
    public var requestProcessFinished: Bool {
        get {
            return self._requestProcessFinished
        }
    }
    
    public var requestSuccessed: Bool {
        get {
            return self._requestSuccessed
        }
    }
    
    public static func create(_ request: ABSRequest) -> ABSRequestor {
        return ABSRequestor(request)
    }
    
    @discardableResult
    public func delegate(_ delegate: ABSCompleteHandlerDelegate) -> ABSRequestor  {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func handler(success: ((ABSRequest, ABSResponse)->())? = nil, fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestor {
        self._handler = ABSBaseCompleteHandler(success: success, fail: fail)
        return self
    }
    
    public func execute() {
        cancel()
        self._requestProcessFinished = false
        self._requestRef = ABSRequestSessionManager.shared.request(self._request, self)
    }
    
    public func cancel() {
        if let theRequestRef = self._requestRef {
            theRequestRef.cancel()
        }
    }
    
}

extension ABSRequestor: ABSCompleteHandlerDelegate {
    
    public func success(_ request: ABSRequest, _ response: ABSResponse) {
        self._handler?.success(request, response)
        self._requestSuccessed = true
        self._requestProcessFinished = true
        self.requestProcessFinish?()
    }
    
    public func fail(_ request: ABSRequest, _ response: ABSResponse) {
        self._handler?.fail(request, response)
        self._requestSuccessed = false
        self._requestProcessFinished = true
        self.requestProcessFinish?()
    }
    
}
