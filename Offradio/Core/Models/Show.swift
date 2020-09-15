//
//  Show.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct Show: Equatable {
    let name: String
    let photo: String
    let largePhoto: String
    let body: String

    static let empty = Show("", photo: "", largePhoto: "", body: "")

    static let `default` = Show("Offradio", photo: "", largePhoto: "", body: "Turn Your Radio Off")

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
    
    static func from(dictionary: [String: Any]) -> Show {
        guard let name = dictionary["name"] as? String,
            let photo = dictionary["photo"] as? String,
            let largePhoto = dictionary["largePhoto"] as? String,
            let body = dictionary["body"] as? String else {
                return Show.empty
            }
        return Show(name, photo: photo, largePhoto: largePhoto, body: body)
    }

    func toDictionary() -> [String: Any] {
        return ["name": name,
                "photo": photo,
                "largephoto": largePhoto,
                "body": body]
    }

}
