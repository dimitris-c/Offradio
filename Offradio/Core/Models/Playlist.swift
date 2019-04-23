//
//  Playlist.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

class PlaylistSong: Object {

    @objc dynamic var time: String = ""
    @objc dynamic var artist: String = ""
    @objc dynamic var songTitle: String = ""
    @objc dynamic var imageUrl: String = ""

    @objc dynamic var sanitizedTitle: String = ""

    @objc dynamic var isFavourite: Bool = false

    convenience init(with json: JSON) {
        self.init()

        self.time = json["time"].stringValue
        self.artist = json["artist"].stringValue.htmlUnescape()
        self.songTitle = json["songtitle"].stringValue.htmlUnescape()
        self.imageUrl = json["imageurl"].stringValue.htmlUnescape()

        self.sanitizedTitle = "\(self.artist) - \(self.songTitle)".lowercased().toBase64()
    }

    convenience init(_ artist: String, songTitle: String, imageUrl: String) {
        self.init()

        self.artist = artist
        self.songTitle = songTitle
        self.imageUrl = imageUrl

        self.sanitizedTitle = "\(self.artist) - \(self.songTitle)".lowercased().toBase64()
    }

    func deepCopy() -> PlaylistSong {
        return PlaylistSong(value: self)
    }

    func toSong() -> Song {
        return Song(with: time, artist: artist, songTitle: songTitle, imageUrl: imageUrl)
    }

    func toCurrentTrack() -> CurrentTrack {
        return CurrentTrack(track: songTitle, image: imageUrl, artist: artist, lastFMImageUrl: "")
    }
}
