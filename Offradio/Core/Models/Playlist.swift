//
//  Playlist.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Realm
import RealmSwift

class PlaylistSong: Object, Decodable {

    @objc dynamic var airedAt: Int = 0
    @objc dynamic var airedDatetime: Date = Date()
    @objc dynamic var artist: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var artistImage: String = ""
    @objc dynamic var trackImage: String = ""

    var sanitizedTitle: String {
        "\(self.artist) - \(self.title)".lowercased().toBase64()
    }

    @objc dynamic var isFavourite: Bool = false
    
    var time: String {
        Formatters.playlistFormatter.string(from: airedDatetime)
    }
    
    var image: String {
        if !trackImage.isEmpty {
            return trackImage
        } else if !artistImage.isEmpty {
            return artistImage
        }
        return ""
    }
    
    enum Keys: String, CodingKey {
        case aired_datetime
        case artist
        case title
        case artist_image
        case track_image
        case aired_at
    }
    
    
    required init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        self.airedAt = try container.decode(Int.self, forKey: .aired_at)
        self.airedDatetime = try container.decode(Date.self, forKey: .aired_datetime)

        self.title = try container.decode(String.self, forKey: .title)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.artistImage = try container.decode(String.self, forKey: .artist_image)
        self.trackImage = try container.decode(String.self, forKey: .track_image)

    }

    convenience init(_ artist: String, songTitle: String, imageUrl: String) {
        self.init()

        self.artist = artist
        self.title = songTitle
        self.trackImage = imageUrl
    }

    func deepCopy() -> PlaylistSong {
        return PlaylistSong(value: self)
    }

    func toSong() -> Song {
        return Song(with: airedDatetime, artist: artist, songTitle: title, trackImage: image)
    }

    func toCurrentTrack() -> CurrentTrack {
        return CurrentTrack(name: title, artist: artist, artistImage: artistImage, trackImage: trackImage, timeAired: "", links: .empty)
    }
}
