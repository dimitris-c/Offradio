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

    static let `default` = Song(with: Date(), artist: "Offradio", songTitle: "#epicmusiconly", trackImage: "")
    
    var time: String {
        Formatters.playlistFormatter.string(from: airedDatetime)
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
    
    enum Keys: String, CodingKey {
        case aired_datetime
        case artist
        case title
        case artist_image
        case track_image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        self.airedDatetime = try container.decode(Date.self, forKey: .aired_datetime)

        self.title = try container.decode(String.self, forKey: .title)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.artistImage = try container.decode(String.self, forKey: .artist_image)
        self.trackImage = try container.decode(String.self, forKey: .track_image)
        
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
