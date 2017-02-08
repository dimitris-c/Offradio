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
    func toData(rawData data: JSON) -> Any // Should be something different from Any, another protocol
}

class APIResponse: ResponseParse {

    final let json: JSON? = nil
    
    func toData(rawData data: JSON) -> Any {
        return data
    }
    
}
