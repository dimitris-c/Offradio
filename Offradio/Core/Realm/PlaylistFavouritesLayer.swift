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
            let sanitizedTitle = "\(artist) - \(title)".lowercased().toBase64()
            return !(realm.objects(PlaylistSong.self).filter("sanitizedTitle = %@ AND isFavourite == true", sanitizedTitle).isEmpty)
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
            let sanitizedTitle = "\(artist) - \(title)".lowercased().toBase64()
            if let item = realm.objects(PlaylistSong.self).filter("sanitizedTitle = %@ ", sanitizedTitle).first {
                try realm.write {
                    realm.delete(item)
                }
            }
        } else {
            throw DataAccessError.connection
        }
    }

    func allFavourites() -> Results<PlaylistSong>? {
        guard let realm = try? database() else {
            return nil
        }
        return realm.objects(PlaylistSong.self)
    }

}

extension CurrentTrack {
    func toPlaylistSong() -> PlaylistSong {
        return PlaylistSong(self.artist, songTitle: self.track, imageUrl: self.image)
    }
}
