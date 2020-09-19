//
//  CurrentTrack.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

struct CurrentTrack: Decodable, Equatable {
    let name: String
    let artist: String
    let artistImage: String
    let trackImage: String
    let timeAired: String
//    let datetimeAired: Date?
    let links: CurrentTrackLinks
    
    var image: String {
        if !trackImage.isEmpty {
            return trackImage
        }
        else if !artistImage.isEmpty {
            return artistImage
        }
        return ""
    }
    
    var title: String {
        guard !artist.isEmpty && !name.isEmpty else {
            return "Turn your radio off"
        }
        return "\(artist) - \(name)"
    }

    static let empty = CurrentTrack(name: "", artist: "", artistImage: "", trackImage: "", timeAired: "", links: .empty)

    static let `default` = CurrentTrack(name: "Turn Your Radio Off", artist: "Offradio", artistImage: "", trackImage: "", timeAired: "", links: .empty)

    static func from(dictionary: [String: Any]) -> CurrentTrack {
        guard let track = dictionary["track"] as? String,
            let artist = dictionary["artist"] as? String,
            let image = dictionary["image"] as? String else {
                return .default
        }
        return CurrentTrack(name: track, artist: artist, artistImage: image, trackImage: "", timeAired: "", links: CurrentTrackLinks.empty)
    }
    
    func toDictionary() -> [String: Any] {
           return ["track": name,
                   "image": image,
                   "artist": artist]
       }
    
    func toSong() -> Song {
        Song(with: Date(), artist: artist, songTitle: name, trackImage: image)
    }
    
    func isEmpty() -> Bool {
        name.isEmpty && artist.isEmpty
    }
}

struct CurrentTrackLinks: Decodable, Equatable {
    let spotify: String
    let apple: String
    let youtube: String
    let soundcloud: String
    
    static let empty = CurrentTrackLinks(spotify: "", apple: "", youtube: "", soundcloud: "")
}
