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
    
    func isEmpty() -> Bool {
        return self.name.isEmpty &&
            self.photo.isEmpty &&
            self.largePhoto.isEmpty &&
            self.body.isEmpty
    }
    
}

struct CurrentTrack {
    let track: String
    let image: String
    let artist: String
    let lastFMImageUrl: String
    
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
        self.lastFMImageUrl = ""
    }
    
    init(track: String, image: String, artist: String, lastFMImageUrl: String) {
        self.track = track
        self.image = image
        self.artist = artist
        self.lastFMImageUrl = lastFMImageUrl
    }
    
    func update(with lastFmImageUrl: String) -> CurrentTrack {
        return CurrentTrack(track: self.track,
                            image: self.image,
                            artist: self.artist,
                            lastFMImageUrl: lastFmImageUrl)
    }
    
    func isEmpty() -> Bool {
        return self.title.isEmpty && self.image.isEmpty && self.artist.isEmpty
    }
}

struct NowPlaying {
    let show: Show
    let current: CurrentTrack
    
    static let empty = NowPlaying(show: .empty, current: .empty)
    
    init(json: JSON) {
        self.show = Show(json: json["show"])
        self.current = CurrentTrack(json: json["current"])
    }
    
    init(show: Show, current: CurrentTrack) {
        self.show = show
        self.current = current
    }
    
    func update(with lastFmImageUrl: String) -> NowPlaying {
        let current = self.current.update(with: lastFmImageUrl)
        return NowPlaying(show: self.show, current: current)
    }
    
    func isEmpty() -> Bool {
        return self.show.isEmpty() && self.current.isEmpty()
    }
}
