//
//  CurrentTrack.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

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
    
    static let `default` = CurrentTrack(track: "Turn Your Radio Off", image: "", artist: "Offradio", lastFMImageUrl: "")
    
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
    
    func toPlaylistSong() -> PlaylistSong {
        return PlaylistSong(self.artist, songTitle: self.track, imageUrl: self.image)
    }
}
