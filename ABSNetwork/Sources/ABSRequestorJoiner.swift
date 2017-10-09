//
//  ABSRequestorJoiner.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation

public protocol ABSRequestorJoinerDelegate: class {
    
    func allRequestFinished(_ allSuccessed: Bool, joiner: ABSRequestorJoiner)
    
}

public extension ABSRequestorJoinerDelegate {
    
    func allRequestFinished(_ allSuccessed: Bool, joiner: ABSRequestorJoinerDelegate) {
        // default do nothing
    }
    
}

public class ABSRequestorJoiner {
    
    private var _identifier: Int?
    public var requestors = [ABSRequestor]()
    public weak var delegate: ABSRequestorJoinerDelegate?
    public var allRequestFinishedCallback: ((Bool, ABSRequestorJoiner)->())?
    
    public init() {
    }
    
    public var identifier: Int? {
        return _identifier
    }
    
    public func identifier(_ identifier: Int?) -> ABSRequestorJoiner {
        _identifier = identifier
        return self
    }
    
    @discardableResult
    public func join(_ requestor: ABSRequestor) -> ABSRequestorJoiner {
        requestor.requestProcessFinish = {[weak self]() in self?.requestorProcessFinish()}
        self.requestors.append(requestor)
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: ABSRequestorJoinerDelegate) -> ABSRequestorJoiner {
        self.delegate = delegate
        return self
    }
    
    public func execute() {
        for requestor in requestors {
            requestor.execute()
        }
    }
    
    public func requestorProcessFinish() {
        var ret = true
        var allSuccessed = true
        for requestor in requestors {
            ret = ret && requestor.requestProcessFinished
            allSuccessed = allSuccessed && requestor.requestSuccessed
        }
        if ret {
            if let theDelegate = self.delegate {
                theDelegate.allRequestFinished(allSuccessed, joiner: self)
            } else {
                allRequestFinishedCallback?(allSuccessed, self)
            }
            
        }
    }
    
    public func cancel() {
        for requestor in self.requestors {
            requestor.cancel()
        }
    }
    
    public func clean() {
        cancel()
        requestors.removeAll()
    }
    
}
