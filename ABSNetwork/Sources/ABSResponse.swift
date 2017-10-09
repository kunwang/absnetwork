//
//  ABSResponse.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation

public class ABSResponse {
    
    private var _data: String?
    private var _headers: [AnyHashable: Any]?
    private var _statusCode: Int?
    private var _error: ABSError?
    
    public init() {
    }
    
    open var data: String? {
        return self._data
    }
    
    open var headers: [AnyHashable: Any]? {
        return self._headers
    }
    open  var statusCode: Int? {
        return self._statusCode
    }
    open var error: ABSError? {
        return self._error
    }
    
    open var dict: [String: Any]? {
        if let theData = self._data {
            return ABSUtils.string2Dict(from: theData)
        }
        return nil
    }
    
    @discardableResult
    public func data(_ data: String?) -> ABSResponse {
        self._data = data
        return self
    }
    
    @discardableResult
    public func headers(_ headers: [AnyHashable: Any]?) -> ABSResponse {
        self._headers = headers
        return self
    }
    
    @discardableResult
    public func statusCode(_ statusCode: Int?) -> ABSResponse {
        self._statusCode = statusCode
        return self
    }
    
    @discardableResult
    public func error(_ error: ABSError?) -> ABSResponse {
        self._error = error
        return self
    }
    
}

public class ABSError {
    private var _message: String = "Error"
    
    public init(_ message: String) {
        self._message = message
    }
    
    public init() {
        
    }
    
    public var message: String {
        return self._message
    }
    
}

public class ABSLocalError: ABSError {
    private var _errorCode: Int
    
    public convenience init(_ errorCode: Int) {
        self.init(errorCode, "Request Local Error")
    }
    
    public init(_ errorCode: Int, _ message: String) {
        self._errorCode = errorCode
        super.init(message)
    }
    
    public var errorCode: Int {
        return self._errorCode
    }
}


public class ABSServerResponseError: ABSError {
    private var _statusCode : Int
    
    public convenience init(_ statusCode: Int) {
        self.init(statusCode, "Request Server Response Error")
    }
    
    public init(_ statusCode: Int, _ message: String) {
        self._statusCode = statusCode
        super.init(message)
    }
    
    public var statusCode: Int {
        return self._statusCode
    }
    
}
