//
//  PlaylistFavourites.swift
//  Offradio
//
//  Created by Dimitris C. on 15/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RealmSwift

struct PlaylistFavouritesLayer: DataLayerProtocol {
    
    func isFavourite(`for` artist: String, songTitle title: String) -> Bool {
        if let realm = try? database() {
            return !(realm.objects(PlaylistSong.self).filter("artist = %@ AND songTitle = %@ AND isFavourite == true", artist, title).isEmpty)
        }
        return false
    }
    
    func createFavourite(with model: PlaylistSong) throws {
        let favourite = PlaylistSong(value: model)
        favourite.isFavourite = true
        try create(item: favourite, update: false)
    }
    
    func deleteFavourite(`for` artist: String, songTitle title: String) throws {
        if let realm = try? database() {
            if let item = realm.objects(PlaylistSong.self).filter("artist = %@ AND songTitle = %@", artist, title).first {
                try realm.write {
                    realm.delete(item)
                }
            }
        } else {
            throw DataAccessError.Connection
        }
    }
    
    func allFavourites() -> Results<PlaylistSong> {
        let realm = try! database()
        return realm.objects(PlaylistSong.self)
    }
    
}
