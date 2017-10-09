//
//  ABSCompleteHandlerDelegate.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation

public protocol ABSCompleteHandlerDelegate: class {
    
    func success(_ request: ABSRequest, _ response: ABSResponse)
    
    func fail(_ request: ABSRequest, _ response: ABSResponse)
    
}

public extension ABSCompleteHandlerDelegate {
    
    func success(_ request: ABSRequest, _ response: ABSResponse) {
        // default do nothing
    }
    
    func fail(_ request: ABSRequest, _ response: ABSResponse) {
        // default do nothing
    }
    
}

public class ABSBaseCompleteHandler: ABSCompleteHandlerDelegate {
    
    // first way: delegate style
    weak var delegate: ABSCompleteHandlerDelegate?
    // second way: closure style, closure must weak reference
    private var _fail: ((ABSRequest, ABSResponse)->())?
    private var _success: ((ABSRequest, ABSResponse)->())?
    
    
    public init(success: ((ABSRequest, ABSResponse)->())? = nil, fail: ((ABSRequest, ABSResponse)->())? = nil) {
        self._success = success
        self._fail = fail
    }
    
    public init(delegate: ABSCompleteHandlerDelegate?) {
        self.delegate = delegate
    }
    
    
    public func fail(_ request: ABSRequest, _ response: ABSResponse) {
        if let theDelegate = self.delegate {
            theDelegate.fail(request, response)
        } else {
            self._fail?(request, response)
        }
    }
    
    public func success(_ request: ABSRequest, _ response: ABSResponse) {
        if let theDelegate = self.delegate {
            theDelegate.success(request, response)
        } else {
            self._success?(request, response)
        }
    }
    
}
