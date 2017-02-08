//
//  NowPlaying.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

struct Show {
    let name: String
    let photo: String
    let largePhoto: String
    let body: String
}

struct CurrentTrack {
    let track: String
    let image: String
    let artist: String
}

struct NowPlaying {
    let show: Show
    let current:CurrentTrack
}
