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
    
    static let empty = Show("", photo: "", largePhoto: "", body: "")
    
    static let `default` = Show("Offradio", photo: "", largePhoto: "", body: "Turn Your Radio Off")
    
    init(json: JSON) {
        self.name = json["name"].stringValue.htmlUnescape()
        self.photo = json["photo"].stringValue
        self.largePhoto = json["largephoto"].stringValue
        self.body = json["body"].stringValue.htmlUnescape()
    }
    
    init(_ name: String, photo: String, largePhoto: String, body: String) {
        self.name = name
        self.photo = photo
        self.largePhoto = largePhoto
        self.body = body
    }
    
    func isEmpty() -> Bool {
        return self.name.isEmpty &&
            self.photo.isEmpty &&
            self.largePhoto.isEmpty &&
            self.body.isEmpty
    }
    
    func toDictionary() -> [String: Any] {
        return ["name": name,
                "photo": photo,
                "largephoto": largePhoto,
                "body": body]
    }

}
