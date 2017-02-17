//
//  PlaylistFavourites.swift
//  Offradio
//
//  Created by Dimitris C. on 15/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RealmSwift

protocol PlaylistFavouritesProtocol: DataLayerProtocol {
    
}

struct PlaylistFavouritesLayer: DataLayerProtocol {
    
    func isFavourite(`for` artist: String, songTitle title: String) -> Bool {
        let realm = try? database()
        return !(realm?.objects(PlaylistSong.self).filter("artist = %@ AND songTitle = %@", artist, title).isEmpty ?? true)
    }
    
    func createFavourite(with model: PlaylistSong) throws {
        let favourite = PlaylistSong(value: model)
        favourite.isFavourite = true
        try create(item: favourite, update: false)
    }
    
    
}
