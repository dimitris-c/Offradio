//
//  NowPlaying.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
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
}

struct CurrentTrack {
    let track: String
    let image: String
    let artist: String
    
    var title: String {
        guard !artist.isEmpty && !track.isEmpty else {
            return "Turn your radio off"
        }
        return artist + " - " + track
    }
    
    static let empty = CurrentTrack(json: "")
    
    init(json: JSON) {
        self.track = json["track"].stringValue
        self.image = json["image"].stringValue
        self.artist = json["artist"].stringValue
    }
}

struct NowPlaying {
    let show: Show
    let current:CurrentTrack
    
    static let empty = NowPlaying(show: .empty, current: .empty)
    
    init(json: JSON) {
        self.show = Show(json: json["show"])
        self.current = CurrentTrack(json: json["current"])
    }
    
    init(show: Show, current: CurrentTrack) {
        self.show = show
        self.current = current
    }
    
}
