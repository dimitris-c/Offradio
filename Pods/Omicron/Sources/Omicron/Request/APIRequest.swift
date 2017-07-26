//
//  Request.swift
//
//  Created by Dimitris C. on 16/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import Alamofire

public final class APIRequest {
        
    final let method: HTTPMethod
    final let apiPath: String
    final let parameters: RequestParameters
    final let headers: HTTPHeaders?

    convenience public init(apiPath path: String, method: HTTPMethod = .get) {
        self.init(apiPath: path, method: method, parameters: RequestParameters())
    }
    
    required public init(apiPath path: String, method: HTTPMethod, parameters params: RequestParameters, headers someHeaders: HTTPHeaders? = nil) {
        self.method = method
        self.apiPath = path
        self.parameters = params
        self.headers = someHeaders
    }
    
    public final func toAlamofire() -> DataRequest {
        return Alamofire.request(self.apiPath,
                                 method: self.method,
                                 parameters: self.parameters.values,
                                 encoding: self.parameters.encoding,
                                 headers: self.headers)
    }

}
