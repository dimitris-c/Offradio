//
//  Producer.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct Producer: Decodable {
    let name: String
    let bio: String
    let image: URL?
    let producerId: Int

}
