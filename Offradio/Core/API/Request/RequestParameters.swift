//
//  Parameters.swift
//  Carlito
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import Alamofire

final class RequestParameters {
    final let values: Parameters?
    final let encoding: ParameterEncoding
    
    convenience init(encoding: ParameterEncoding = URLEncoding.default){
        self.init(parameters: nil, encoding: encoding)
    }
    
    init(parameters params: Parameters?, encoding anEncoding: ParameterEncoding = URLEncoding.default) {
        self.values = params
        self.encoding = anEncoding
    }
}
