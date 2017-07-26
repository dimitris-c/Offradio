//
//  Parameters.swift
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import Alamofire

public final class RequestParameters {
    final let values: Parameters?
    final let encoding: ParameterEncoding
    
    /// Empty URLEncoded parameters
    public static let `default` = RequestParameters(encoding: URLEncoding.default)
    
    /// Empty parameters with `URLEncoding.default`
    convenience public init(encoding: ParameterEncoding = URLEncoding.default){
        self.init(parameters: nil, encoding: encoding)
    }
    
    public init(parameters params: Parameters?, encoding anEncoding: ParameterEncoding = URLEncoding.default) {
        self.values = params
        self.encoding = anEncoding
    }
    
}
