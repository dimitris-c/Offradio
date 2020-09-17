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
    @objc dynamic var links: PlaylistSongLinks? = PlaylistSongLinks()

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
        case links
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
        
        self.links = try container.decodeIfPresent(PlaylistSongLinks.self, forKey: .links)
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

class PlaylistSongLinks: Object, Decodable {
    @objc dynamic var spotify: String = ""
    @objc dynamic var apple: String = ""
    @objc dynamic var youtube: String = ""
    @objc dynamic var soundcloud: String = ""
    
    var hasSpotify: Bool {
        !spotify.isEmpty
    }
    
    var hasAppleMusic: Bool {
        !apple.isEmpty
    }
    
    convenience init(spotify: String, apple: String, youtube: String, soundcloud: String) {
        self.init()
        self.spotify = spotify
        self.apple = apple
        self.youtube = youtube
        self.soundcloud = soundcloud
    }
    
    required init() {
        super.init()
    }
    
    static let empty = CurrentTrackLinks(spotify: "", apple: "", youtube: "", soundcloud: "")
}
