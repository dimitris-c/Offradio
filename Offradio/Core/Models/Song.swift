//
//  Song.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

/// Alias of PlaylistSong for use in watch without Realm dependancies
struct Song: Decodable {
    let airedDatetime: Date
    let artist: String
    let title: String
    let artistImage: String
    let trackImage: String

//    var isFavourite: Bool = false
    
    var time: String {
        Formatters.apiDateFormatter.string(from: airedDatetime)
    }
    
    var image: String {
        if !trackImage.isEmpty {
            return trackImage
        }
        else if !artistImage.isEmpty {
            return artistImage
        }
        return ""
    }
    
    var titleFormatted: String {
        guard !artist.isEmpty && !title.isEmpty else {
            return "Turn your radio off"
        }
        return "\(artist) - \(title)"
    }
    
    init(with date: Date, artist: String, songTitle: String, trackImage: String) {
        self.airedDatetime = date
        self.artist = artist
        self.title = songTitle
        self.trackImage = trackImage
        self .artistImage = ""
    }
    
    static func from(dictionary: [String: Any]) -> Song {
        guard let artist = dictionary["artist"] as? String,
              let songtitle = dictionary["songtitle"] as? String,
              let imageUrl = dictionary["imageUrl"] as? String,
              let time = dictionary["time"] as? Date else {
            return Song(with: Date(), artist: "", songTitle: "", trackImage: "")
        }
        return Song(with: time, artist: artist, songTitle: songtitle, trackImage: imageUrl)
    }

    func toDictionary() -> [String: Any] {
        return ["time": airedDatetime,
                "artist": artist,
                "songtitle": title,
                "imageUrl": image]
    }
}
