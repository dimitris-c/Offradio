//
//  APIResponse.swift
//  Carlito
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ResponseParse {
    associatedtype Model
    func toData(rawData data: JSON) -> Model?
}

class APIResponse<T>: ResponseParse {
    // default implemention does nothing...
    func toData(rawData data: JSON) -> T? {
        return data as? T
    }
    
}

class JSONResponse: APIResponse<JSON> {
    override func toData(rawData data: JSON) -> JSON {
        return data
    }
}
