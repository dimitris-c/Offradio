//
//  DummyModel.swift
//  Offradio
//
//  Created by Dimitris C. on 25/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct DummyModel {
    let name: String
    let lastName: String
    
    var fullName: String {
        return "\(name) \(lastName)"
    }
    
    init(with json: JSON) {
        self.name = json["name"].stringValue
        self.lastName = json["lastname"].stringValue
    }
}
    
