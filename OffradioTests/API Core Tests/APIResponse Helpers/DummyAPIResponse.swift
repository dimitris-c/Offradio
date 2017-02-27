//
//  DummyAPIResponse.swift
//  Offradio
//
//  Created by Dimitris C. on 25/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
@testable import Offradio

class DummyAPIResponse: APIResponse<DummyModel> {
    
    override func toData(rawData data: JSON) -> DummyModel? {
        return DummyModel(with: data)
    }
    
}

class ArrayDummyAPIResponse: APIResponse<[DummyModel]> {
    
    override func toData(rawData data: JSON) -> [DummyModel]? {
        return data["persons"].arrayValue.map { DummyModel(with: $0) }
    }
    
}
