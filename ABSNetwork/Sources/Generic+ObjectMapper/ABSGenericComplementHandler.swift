//
//  ABSGenericComplementHandler.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ABSGenericCompleteHandlerDelegate: class {
    
    associatedtype T: Mappable
    
    func success(_ request: ABSRequest, _ response: ABSGenericResponse<T>)
    
    func fail(_ request: ABSRequest, _ response: ABSGenericResponse<T>)
    
}

public extension ABSGenericCompleteHandlerDelegate {
    
    func success(_ request: ABSRequest, _ response: ABSGenericResponse<T>) {
        // default do nothing
    }
    
    func fail(_ request: ABSRequest, _ response: ABSGenericResponse<T>) {
        // default do nothing
    }
}

public class ABSAnyGenericCompleteHandler<Delegate: ABSGenericCompleteHandlerDelegate>: ABSCompleteHandlerDelegate {
    
    private weak var delegate: Delegate?
    
    public init(delegate: Delegate) {
        self.delegate = delegate
    }
    
    
    public func fail(_ request: ABSRequest, _ response: ABSResponse) {
        let genericResponse = ABSGenericResponse<Delegate.T>().from(response)
        delegate?.fail(request, genericResponse)
    }
    
    public func success(_ request: ABSRequest, _ response: ABSResponse) {
        let genericResponse = ABSGenericResponse<Delegate.T>().from(response)
        delegate?.success(request, genericResponse)
    }
    
}

public class ABSGenericBaseCompleteHandler<T: Mappable>: ABSCompleteHandlerDelegate {
    
    private var _fail: ((ABSRequest, ABSGenericResponse<T>)->())?
    
    private var _success: ((ABSRequest, ABSGenericResponse<T>)->())?
    
    
    public init(success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil, fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) {
        self._success = success
        self._fail = fail
    }
    
    public func fail(_ request: ABSRequest, _ response: ABSResponse) {
        let genericResponse = ABSGenericResponse<T>().from(response)
        self._fail?(request, genericResponse)
    }
    
    public func success(_ request: ABSRequest, _ response: ABSResponse) {
        let genericResponse = ABSGenericResponse<T>().from(response)
        self._success?(request, genericResponse)
    }
    
}

public protocol ABSGenericArrayCompleteHandlerDelegate: class {
    
    associatedtype T: Mappable
    
    func success(_ request: ABSRequest, _ response: ABSGenericArrayResponse<T>)
    
    func fail(_ request: ABSRequest, _ response: ABSGenericArrayResponse<T>)
    
}

public extension ABSGenericArrayCompleteHandlerDelegate {
    
    func success(_ request: ABSRequest, _ response: ABSGenericArrayResponse<T>) {
        // default do nothing
    }
    
    func fail(_ request: ABSRequest, _ response: ABSGenericArrayResponse<T>) {
        // default do nothing
    }
    
}

public class ABSAnyGenericArrayCompleteHandler<Delegate: ABSGenericArrayCompleteHandlerDelegate>: ABSCompleteHandlerDelegate {
    
    private weak var delegate: Delegate?
    
    public init(delegate: Delegate) {
        self.delegate = delegate
    }
    
    public func fail(_ request: ABSRequest, _ response: ABSResponse) {
        let genericArrayResponse = ABSGenericArrayResponse<Delegate.T>().from(response)
        delegate?.fail(request, genericArrayResponse)
    }
    
    public func success(_ request: ABSRequest, _ response: ABSResponse) {
        let genericArrayResponse = ABSGenericArrayResponse<Delegate.T>().from(response)
        delegate?.success(request, genericArrayResponse)
    }
    
}

public class ABSGenericArrayBaseCompleteHandler<T: Mappable>: ABSCompleteHandlerDelegate {
    
    private var _fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())?
    
    private var _success: ((ABSRequest, ABSGenericArrayResponse<T>)->())?
    
    
    public init(success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil, fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) {
        self._success = success
        self._fail = fail
    }
    
    public func fail(_ request: ABSRequest, _ response: ABSResponse) {
        let genericArrayResponse = ABSGenericArrayResponse<T>().from(response)
        self._fail?(request, genericArrayResponse)
    }
    
    public func success(_ request: ABSRequest, _ response: ABSResponse) {
        let genericArrayResponse = ABSGenericArrayResponse<T>().from(response)
        self._success?(request, genericArrayResponse)
    }
    
}
