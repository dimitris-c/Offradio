//
//  Request.swift
//  Carlito
//
//  Created by Dimitris C. on 16/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import Alamofire

final class APIRequest {
        
    final let method: HTTPMethod
    final let url: String
    final let parameters: RequestParameters
    final let headers: HTTPHeaders?
    
    convenience init(apiPath path: String, method: HTTPMethod = .get) {
        self.init(apiPath: path, method: method, parameters: RequestParameters())
    }
    
    required init(apiPath path: String,
                  method: HTTPMethod,
                  parameters params: RequestParameters,
                             headers someHeaders: HTTPHeaders? = nil) {
        self.method = method
        self.url = path
        self.parameters = params
        
        self.headers = someHeaders
    }
    
    func toAlamofire() -> DataRequest {
        return Alamofire.request(self.url,
                                 method: self.method,
                                 parameters: self.parameters.values,
                                 encoding: self.parameters.encoding,
                                 headers: self.headers)
    }

}
