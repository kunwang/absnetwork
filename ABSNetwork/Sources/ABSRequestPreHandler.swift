//
//  ABSRequestPreHandler.swift
//  ABSNetwork
//
//  Created by abstractwang on 2017/10/9.
//  Copyright © 2017年 com.abswang. All rights reserved.
//

import Foundation

public protocol ABSRequestPreHandler: class {
    
    // if return ture, the next pre handlers will continue executing
    // if return false, the next pre handlers will not continue executing and request will return
    func process(_ manager: ABSRequestSessionManager, _ request: ABSRequest) -> Bool
    
}
