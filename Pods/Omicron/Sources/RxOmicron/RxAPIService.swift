//
//  RxAPIServiceTyped.swift
//  Omicron
//
//  Created by Dimitris C. on 24/06/2017.
//  Copyright © 2017 Decimal. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON
#if !COCOAPODS
    import Omicron
#endif

/**
 A Reactive service which requires the passed ServiceRequest to conform to a Service protocol
 Duplicate of `APIService`.
 */
open class RxAPIService<ServiceRequest: Service>: APIService<ServiceRequest> {
    
    public func call<Model>(with service: ServiceRequest, parse: APIResponse<Model>) -> Observable<Model> {
        return self.call(request: request(from: service), parse: parse)
    }
    
    public func callJSON(with service: ServiceRequest) -> Observable<JSON> {
        return self.callJSON(request: request(from: service))
    }
    
    public func callString(with service: ServiceRequest) -> Observable<String> {
        return self.callString(request: request(from: service))
    }
    
    public func callData(with service: ServiceRequest) -> Observable<Data> {
        return self.callData(request: request(from: service))
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
