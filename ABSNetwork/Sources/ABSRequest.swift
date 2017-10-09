//
//  ABSRequest.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation
import Alamofire

open class ABSRequest {
    
    private var _url: String
    private var _params: [String: Any]?
    private var _data: Data?
    private var _headers = [String: String]()
    private var _multipartFormData: ABSRequestMultipartFormData?
    private var _httpMethod: HTTPMethod = .get
    private var _identifier: Int?
    private var _retryTimes:Int = 0
    
    public init(_ url: String) {
        self._url = url
    }
    
    open static func create(_ url: String) -> ABSRequest {
        return ABSRequest(url)
    }
    
    @discardableResult
    open func params(_ params: [String: Any]?) -> ABSRequest {
        self._params = params
        return self
    }
    
    @discardableResult
    open func headers(_ headers: [String: String]) -> ABSRequest {
        self._headers = headers
        return self
    }
    
    @discardableResult
    open func method(_ method: HTTPMethod) -> ABSRequest  {
        self._httpMethod = method
        return self
    }
    
    @discardableResult
    open func data(_ data: Data?) -> ABSRequest {
        self._data = data
        return self
    }
    
    @discardableResult
    open func retryTimes(_ retryTimes: Int) -> ABSRequest {
        self._retryTimes = retryTimes
        return self
    }
    
    @discardableResult
    open func identifier(_ identifier: Int?) -> ABSRequest {
        self._identifier = identifier
        return self
    }
    
    @discardableResult
    open func url(_ url: String) -> ABSRequest {
        self._url = url
        return self
    }
    
    @discardableResult
    open func multipartFormData(_ multipartFormData: ABSRequestMultipartFormData?) -> ABSRequest {
        self._multipartFormData = multipartFormData
        return self
    }
    
    open func isUpload() -> Bool {
        return _data != nil
    }
    
    open func isMultipartFormUpload() -> Bool {
        return self.multipartFormData != nil
    }
    
    open var params: [String: Any]? {
        return self._params
    }
    
    open var headers: [String: String] {
        return self._headers
    }
    
    open var url: String {
        return self._url
    }
    
    open var method: HTTPMethod {
        return self._httpMethod
    }
    
    open var data: Data? {
        return self._data
    }
    
    open var retryTimes: Int {
        return self._retryTimes
    }
    
    open var identifier: Int? {
        return self._identifier
    }
    
    open var multipartFormData: ABSRequestMultipartFormData? {
        return self._multipartFormData
    }
    
}
