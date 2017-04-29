//
//  Song.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct Song {
    let time: String
    let artist: String
    let songTitle: String
    let imageUrl: String
 
    init(with json: JSON) {
        
        self.time = json["time"].stringValue
        self.artist = json["artist"].stringValue.htmlUnescape()
        self.songTitle = json["songtitle"].stringValue.htmlUnescape()
        self.imageUrl = json["imageurl"].stringValue.htmlUnescape()
        
    }
    
    func toDictionary() -> [String: Any] {
        return ["time": time,
                "artist": artist,
                "songTitle": songTitle,
                "imageUrl": imageUrl]
    }
}
