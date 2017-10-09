//
//  ABSRequestSessionManager+Generic.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

// Mark:- generic response
public extension ABSRequestSessionManager {
    
    // GET
    @discardableResult
    public func get<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.get, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // POST
    @discardableResult
    public func post<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // PATCH
    @discardableResult
    public func patch<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.patch, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // PUT
    @discardableResult
    public func put<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.put, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // UPLOAD
    @discardableResult
    public func upload<T: Mappable>(_ url: String
        , data: Data
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, data: data, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // MULTIPART FORM UPLOAD
    @discardableResult
    public func multiformUpload<T: Mappable>(_ url: String
        , multipartFormData: ABSRequestMultipartFormData
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, multipartFormData: multipartFormData, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    @discardableResult
    public func request<T: Mappable>(_ method: HTTPMethod
        , _ url: String
        , params: [String: Any]? = nil
        , data: Data? = nil
        , multipartFormData: ABSRequestMultipartFormData? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericResponse<T>)->())? = nil) -> ABSRequestRef {
        let request = ABSRequest(url).params(params).headers(headers).retryTimes(retryTimes).method(method).data(data).identifier(identifier).multipartFormData(multipartFormData)
        let handler = ABSGenericBaseCompleteHandler(success: success, fail: fail)
        return self.request(request, handler)
    }
    
    @discardableResult
    public func request<Delegate: ABSGenericCompleteHandlerDelegate>(_ request: ABSRequest, _ delegate: Delegate) -> ABSRequestRef {
        let genericHandler = ABSAnyGenericCompleteHandler<Delegate>(delegate: delegate)
        return self.request(request, genericHandler)
    }
    
}

// Mark:- generic array response
public extension ABSRequestSessionManager {
    
    // GET
    @discardableResult
    public func get<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.get, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // POST
    @discardableResult
    public func post<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // PATCH
    @discardableResult
    public func patch<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.patch, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // PUT
    @discardableResult
    public func put<T: Mappable>(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.put, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // UPLOAD
    @discardableResult
    public func upload<T: Mappable>(_ url: String
        , data: Data
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, data: data, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // MULTIPART FORM UPLOAD
    @discardableResult
    public func multiformUpload<T: Mappable>(_ url: String
        , multipartFormData: ABSRequestMultipartFormData
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, multipartFormData: multipartFormData, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    @discardableResult
    public func request<T: Mappable>(_ method: HTTPMethod
        , _ url: String
        , params: [String: Any]? = nil
        , data: Data? = nil
        , multipartFormData: ABSRequestMultipartFormData? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil
        , fail: ((ABSRequest, ABSGenericArrayResponse<T>)->())? = nil) -> ABSRequestRef {
        let request = ABSRequest(url).params(params).headers(headers).retryTimes(retryTimes).method(method).data(data).identifier(identifier).multipartFormData(multipartFormData)
        let handler = ABSGenericArrayBaseCompleteHandler(success: success, fail: fail)
        return self.request(request, handler)
    }
    
    @discardableResult
    public func request<Delegate: ABSGenericArrayCompleteHandlerDelegate>(_ request: ABSRequest, _ delegate: Delegate) -> ABSRequestRef {
        let genericArrayHandler = ABSAnyGenericArrayCompleteHandler<Delegate>(delegate: delegate)
        return self.request(request, genericArrayHandler)
    }
    
}
