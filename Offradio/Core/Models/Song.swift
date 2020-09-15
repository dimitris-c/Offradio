//
//  Song.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

/// Alias of PlaylistSong for use in watch without Realm dependancies
struct Song: Decodable {
    let airedDatetime: Date
    let artist: String
    let title: String
//    let artistImage: String
    let trackImage: String

//    let sanitizedTitle: String

//    var isFavourite: Bool = false
    
    var time: String {
        Formatters.apiDateFormatter.string(from: airedDatetime)
    }
    
    var titleFormatted: String {
        guard !artist.isEmpty && !title.isEmpty else {
            return "Turn your radio off"
        }
        return "\(artist) - \(title)"
    }
    
    init(with date: Date, artist: String, songTitle: String, imageUrl: String) {
        self.airedDatetime = date
        self.artist = artist
        self.title = songTitle
        self.trackImage = imageUrl
    }

    func toDictionary() -> [String: Any] {
        return ["time": time,
                "artist": artist,
                "songtitle": title,
                "imageUrl": trackImage]
    }
}
