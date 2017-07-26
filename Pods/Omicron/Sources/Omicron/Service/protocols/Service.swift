//
//  ServiceType.swift
//
//  Created by Dimitris Chatzieleftheriou on 24/05/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Alamofire

public protocol Service {
    /// The target's base `URL`.
    var baseURL: URL { get }
    
    /// The path of the request
    var path: String { get }
    
    /// The method of the request, eg. .get
    var method: HTTPMethod { get }
    
    /// Any parameters for the request
    var params: RequestParameters { get }
    
}
