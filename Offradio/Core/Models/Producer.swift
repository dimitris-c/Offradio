//
//  Producer.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct Producer {
    let name: String
    let bio: String
    let photoUrl: String

    init(with json: JSON) {
        self.name   = json["name"].stringValue
        self.bio    = json["bio"].stringValue
        self.photoUrl = json["photo"].stringValue
    }

}
