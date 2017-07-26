//
//  APIServiceTyped.swift
//  Omicron
//
//  Created by Dimitris C. on 19/06/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 A Typed service which requires the passed ServiceType to conform to a ServiceRequestType protocol
 Inspired by the Moya framework.
 
 The ServiceRequestType needs a bit of setup but makes things easier for grouping a set of api calls.
 */
open class APIService<ServiceRequest: Service> {
    
    public init() { }
    
    @discardableResult
    public func call<Model>(with service: ServiceRequest, parse: APIResponse<Model>, _ completion: @escaping CompletionBlock<Model>) -> Request {
        return self.call(request: request(from: service), parse: parse, completion)
    }
    
    @discardableResult
    public func callJSON(with service: ServiceRequest, _ completion: @escaping CompletionBlock<JSON>) -> Request {
        return self.callJSON(request: request(from: service), completion)
    }
    
    @discardableResult
    public func callString(with service: ServiceRequest, _ completion: @escaping CompletionBlock<String>) -> Request {
        return self.callString(request: request(from: service), completion)
    }
    
    @discardableResult
    public func callData(with service: ServiceRequest, _ completion: @escaping CompletionBlock<Data>) -> Request {
        return self.callData(request: request(from: service), completion)
    }
    
    private final func request(from service: ServiceRequest) -> APIRequest {
        let apiPath = type(of: self).url(for: service).absoluteString
        return APIRequest(apiPath: apiPath, method: service.method, parameters: service.params)
    }
    
    private final class func url(`for` service: ServiceRequest) -> URL {
        if service.path.isEmpty {
            return service.baseURL
        }
        return service.baseURL.appendingPathComponent(service.path)
    }
    
}
