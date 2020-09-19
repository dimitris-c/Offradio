//
//  PlaylistController.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import Kingfisher

class PlaylistController: WKInterfaceController {
    
    let communication = OffradioWatchCommunication()
    
    @IBOutlet var playlistTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func didAppear() {
        super.didAppear()
        
        self.communication.getPlaylist { [weak self] data in
            if let songs = data["data"] as? [[String: Any]] {
                let final = songs.map(Song.from(dictionary:))
                self?.populateRows(songs: final)
            }
        }
        
    }
    
    fileprivate func populateRows(songs: [Song]) {
        self.playlistTable.setNumberOfRows(songs.count, withRowType: "playlistRow")
        for (index,song) in songs.enumerated() {
            if let cell = self.playlistTable.rowController(at: index) as? PlaylistTableViewRow {
                cell.songTitle.setText(song.title)
                cell.timeLabel.setText(song.time)
                if let url = URL(string: song.trackImage) {
                    cell.image.kf.setImage(with: url)
                }
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
}
