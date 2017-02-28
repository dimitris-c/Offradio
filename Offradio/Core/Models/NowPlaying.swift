//
//  NowPlaying.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON

struct NowPlaying {
    let show: Show
    let current: CurrentTrack
    
    static let empty = NowPlaying(show: .empty, current: .empty)
    
    init(json: JSON) {
        self.show = Show(json: json["show"])
        self.current = CurrentTrack(json: json["current"])
    }
    
    init(show: Show, current: CurrentTrack) {
        self.show = show
        self.current = current
    }
    
    func update(with lastFmImageUrl: String) -> NowPlaying {
        let current = self.current.update(with: lastFmImageUrl)
        return NowPlaying(show: self.show, current: current)
    }
    
    func isEmpty() -> Bool {
        return self.show.isEmpty() && self.current.isEmpty()
    }
}
