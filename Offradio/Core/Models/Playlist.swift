//
//  Playlist.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

struct PlaylistSong {
    let time: String
    let artist: String
    let songTitle: String
    let imageUrl: String
}

struct Playlist {
    let items: [PlaylistSong]
    let page: Int
}
