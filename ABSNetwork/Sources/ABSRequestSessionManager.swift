//
//  ABSRequestSessionManager.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Alamofire

open class ABSRequestSessionManager: Alamofire.SessionManager {
    
    public static let defaultRequestTimeout: Double = 60
    public static let multipartFormUploadEncodingErrorCode = 9002
    public static let shared = ABSRequestSessionManager(ABSRequestSessionManager.defaultRequestTimeout)
    
    private var requestPreHandlers = [ABSRequestPreHandler]()
    private var responsePostHandlers = [ABSResponsePostHandler]()
    
    // MARK:- requestTimeout is single request timeout, but retry increment requests
    open static func get(_ requestTimeout: Double = defaultRequestTimeout) -> ABSRequestSessionManager {
        if requestTimeout == ABSRequestSessionManager.defaultRequestTimeout {
            return shared
        } else {
            return ABSRequestSessionManager(requestTimeout)
        }
    }
    
    public init(_ requestTimeout: Double) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = requestTimeout
        configuration.timeoutIntervalForResource = requestTimeout
        super.init(configuration: configuration)
        self.configRequestPreHandlers()
        self.configResponsePostHandlers()
    }
    
    // request pre handlers init
    open func configRequestPreHandlers() {
        self.requestPreHandlers.append(ABSRequestPreCommonHeaderHandler.shared)
    }
    
    // request pre handlers init
    open func configRequestPreHandlers(_ handlers: [ABSRequestPreHandler]) {
        self.requestPreHandlers.removeAll()
        self.requestPreHandlers.append(contentsOf: handlers)
    }
    
    // reponse post handers init
    open func configResponsePostHandlers() {
        responsePostHandlers.append(ABSResponsePostRetryHandler.shared)
    }
    
    // reponse post handers init
    open func configResponsePostHandlers(_ handlers: [ABSResponsePostHandler]) {
        self.responsePostHandlers.removeAll()
        self.responsePostHandlers.append(contentsOf: handlers)
    }
    
    // Mark :- public methods
    
    // GET
    @discardableResult
    open func get(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSResponse)->())? = nil
        , fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestRef {
        return self.request(.get, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // POST
    @discardableResult
    open func post(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSResponse)->())? = nil
        , fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // PATCH
    @discardableResult
    open func patch(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSResponse)->())? = nil
        , fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestRef {
        return self.request(.patch, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // PUT
    @discardableResult
    open func put(_ url: String
        , params: [String: Any]? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSResponse)->())? = nil
        , fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestRef {
        return self.request(.put, url, params: params, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // UPLOAD
    @discardableResult
    open func upload(_ url: String
        , data: Data
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSResponse)->())? = nil
        , fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, data: data, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // MULTIPART FORM UPLOAD
    @discardableResult
    open func multiformUpload(_ url: String
        , multipartFormData: ABSRequestMultipartFormData
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSResponse)->())? = nil
        , fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestRef {
        return self.request(.post, url, multipartFormData: multipartFormData, headers: headers, retryTimes: retryTimes, identifier: identifier, success: success, fail: fail)
    }
    
    // EXECUTE REQUEST
    @discardableResult
    open func request(_ method: HTTPMethod
        , _ url: String
        , params: [String: Any]? = nil
        , data: Data? = nil
        , multipartFormData: ABSRequestMultipartFormData? = nil
        , headers: [String:String] = [:]
        , retryTimes: Int = 0
        , identifier: Int? = nil
        , success: ((ABSRequest, ABSResponse)->())? = nil
        , fail: ((ABSRequest, ABSResponse)->())? = nil) -> ABSRequestRef {
        let request = ABSRequest(url).params(params).headers(headers).retryTimes(retryTimes).method(method).data(data).identifier(identifier).multipartFormData(multipartFormData)
        let handler = ABSBaseCompleteHandler(success: success, fail: fail)
        return self.request(request, handler)
    }
    
    // EXECUTE REQUEST
    @discardableResult
    open func request(_ request: ABSRequest, _ handler: ABSCompleteHandlerDelegate? = nil) -> ABSRequestRef {
        let requestRef = ABSRequestRef()
        for requestPreHandler in self.requestPreHandlers {
            if !requestPreHandler.process(self, request) {
                return requestRef
            }
        }
        self.requestExecute(requestRef, request, handler)
        return requestRef
    }
    
    public func requestExecute(_ requestRef: ABSRequestRef, _ request: ABSRequest, _ handler: ABSCompleteHandlerDelegate?) {
        if request.isMultipartFormUpload() { // multi form data upload
            multiFormRequest(requestRef, request, handler)
        } else { // normal request
            nonMultiFormRequest(requestRef, request, handler)
        }
    }
    
    private func nonMultiFormRequest( _ requestRef: ABSRequestRef, _ request: ABSRequest, _ handler: ABSCompleteHandlerDelegate?) {
        let dataRequest: DataRequest!
        if request.isUpload() {
            dataRequest = self.upload(request.data!, to: request.url, method: .post, headers: request.headers)
        } else {
            let encoding: ParameterEncoding = (request.method == .get ? URLEncoding.default : JSONEncoding.default)
            dataRequest = self.request(request.url, method: request.method, parameters: request.params, encoding: encoding, headers: request.headers)
        }
        requestRef.requestRef = dataRequest.responseString(completionHandler: {[weak self](dataResponse: DataResponse<String>) in
            self?.responseCompletionHandler(dataResponse, requestRef, request, handler)
        })
    }
    
    private func multiFormRequest( _ requestRef: ABSRequestRef, _ request: ABSRequest, _ handler: ABSCompleteHandlerDelegate?) {
        self.upload(multipartFormData: {(multipartFormData) in
            if let theFormDataItems = request.multipartFormData?.getMultipartFromDataItems() {
                for item in theFormDataItems {
                    item.append(to: multipartFormData)
                }
            }
        }, to: request.url, headers: request.headers, encodingCompletion: {[weak self](result) in
            switch result {
            case .success(let uploadRequest, _, _):
                // progress delegate
                uploadRequest.uploadProgress(closure: {(progress) in
                    request.multipartFormData?.progress(progress)
                })
                uploadRequest.responseString(completionHandler: {(dataResponse: DataResponse<String>) in
                    self?.responseCompletionHandler(dataResponse, requestRef, request, handler)
                })
            case .failure(let error):
                let response = ABSResponse().error(ABSLocalError(ABSRequestSessionManager.multipartFormUploadEncodingErrorCode, error.localizedDescription))
                self?.responseCompletionHandler(response, requestRef, request, handler)
            }
        })
    }
    
    func responseCompletionHandler(_ dataResponse: DataResponse<String>,  _ requestRef: ABSRequestRef, _ request: ABSRequest, _ handler: ABSCompleteHandlerDelegate?) {
        let response = ABSResponse().data(dataResponse.result.value).headers(dataResponse.response?.allHeaderFields).error(self.extraError(dataResponse)).statusCode(dataResponse.response?.statusCode)
        responseCompletionHandler(response, requestRef, request, handler)
    }
    
    func responseCompletionHandler(_ response: ABSResponse,  _ requestRef: ABSRequestRef, _ request: ABSRequest, _ handler: ABSCompleteHandlerDelegate?) {
        for responsePostHandler in self.responsePostHandlers {
            if !responsePostHandler.process(requestRef, self, request, response, handler) {
                return
            }
        }
        if let _ = response.error {
            handler?.fail(request, response)
        } else {
            handler?.success(request, response)
        }
    }
    
    open func extraError(_ response: DataResponse<String>) -> ABSError? {
        // local error
        if let theError = response.result.error as NSError? {
            return ABSLocalError(theError.code)
        }
        // server response error
        if let theStatusCode = response.response?.statusCode {
            if theStatusCode >= 200 && theStatusCode < 300 {
                return nil
            } else {
                return ABSServerResponseError(theStatusCode)
            }
        }
        return ABSError("Unknown Error")
    }
    
}

// request reference to process request
open class ABSRequestRef {
    
    public init() {
    }
    
    var requestRef: Alamofire.Request?
    
    open func cancel() {
        if let theRef = self.requestRef {
            theRef.cancel()
        }
    }
    
}
