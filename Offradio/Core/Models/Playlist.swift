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
    
    dynamic var time: String = ""
    dynamic var artist: String = ""
    dynamic var songTitle: String = ""
    dynamic var imageUrl: String = ""
    
//    dynamic var sanitizedTitle: String = ""
    
    dynamic var isFavourite: Bool = false
    
    convenience init(with json: JSON) {
        self.init()
        
        self.time = json["time"].stringValue
        self.artist = json["artist"].stringValue.htmlUnescape()
        self.songTitle = json["songtitle"].stringValue.htmlUnescape()
        self.imageUrl = json["imageurl"].stringValue.htmlUnescape()
        
    }
    
    convenience init(_ artist: String, songTitle: String, imageUrl: String) {
        self.init()
        
        self.artist = artist
        self.songTitle = songTitle
        self.imageUrl = imageUrl
    }

    func deepCopy() -> PlaylistSong {
        return PlaylistSong(value: self)
    }
    
}
