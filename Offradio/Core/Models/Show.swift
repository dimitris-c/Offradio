//
//  Show.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct Show {
    let name: String
    let photo: String
    let largePhoto: String
    let body: String
    
    static let empty = Show(json: JSON([]))
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.photo = json["photo"].stringValue
        self.largePhoto = json["largephoto"].stringValue
        self.body = json["body"].stringValue
    }
    
    func isEmpty() -> Bool {
        return self.name.isEmpty &&
            self.photo.isEmpty &&
            self.largePhoto.isEmpty &&
            self.body.isEmpty
    }
    
}
