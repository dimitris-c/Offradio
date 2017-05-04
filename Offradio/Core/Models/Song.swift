//
//  Song.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
/// Alias of PlaylistSong for use in watch without Realm dependancies
struct Song {
    let time: String
    let artist: String
    let songTitle: String
    let imageUrl: String
 
    var title: String {
        guard !artist.isEmpty && !songTitle.isEmpty else {
            return "Turn your radio off"
        }
        return "\(artist) - \(songTitle)"
    }
    
    init(with json: JSON) {
        
        self.time = json["time"].stringValue
        self.artist = json["artist"].stringValue.htmlUnescape()
        self.songTitle = json["songtitle"].stringValue.htmlUnescape()
        self.imageUrl = json["imageurl"].stringValue.htmlUnescape()
        
    }
    
    init(with time:String, artist: String, songTitle: String, imageUrl: String) {
        self.time = time
        self.artist = artist
        self.songTitle = songTitle
        self.imageUrl = imageUrl
    }
    
    func toDictionary() -> [String: Any] {
        return ["time": time,
                "artist": artist,
                "songtitle": songTitle,
                "imageUrl": imageUrl]
    }
}
