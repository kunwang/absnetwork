//
//  ABSGenericResponse.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation
import ObjectMapper

public class ABSGenericResponse<T: Mappable>: ABSResponse {
    
    public override init() {}
    
    private var _model: T?
    
    open var model: T? {
        return _model
    }
    
    @discardableResult
    public func model(_ model: T?) -> ABSGenericResponse<T> {
        self._model = model
        return self
    }
    
    public func from(_ response: ABSResponse) -> ABSGenericResponse<T> {
        let genericResponse = ABSGenericResponse<T>()
        genericResponse.data(response.data)
        genericResponse.headers(response.headers)
        genericResponse.statusCode(response.statusCode)
        genericResponse.error(response.error)
        if let data = response.data, let model = Mapper<T>().map(JSONString: data) {
            genericResponse.model(model)
        }
        return genericResponse
    }
    
}

public class ABSGenericArrayResponse<T: Mappable>: ABSResponse {
    
    public override init() {}
    
    private var _models: [T]?
    
    open var models: [T]? {
        return _models
    }
    
    @discardableResult
    public func models(_ models: [T]?) -> ABSGenericArrayResponse<T> {
        self._models = models
        return self
    }
    
    
    public func from(_ response: ABSResponse) -> ABSGenericArrayResponse<T> {
        let genericArrayResponse = ABSGenericArrayResponse<T>()
        genericArrayResponse.data(response.data)
        genericArrayResponse.headers(response.headers)
        genericArrayResponse.statusCode(response.statusCode)
        genericArrayResponse.error(response.error)
        if let data = response.data, let models = Mapper<T>().mapArray(JSONString: data) {
            genericArrayResponse.models(models)
        }
        return genericArrayResponse
    }
}
