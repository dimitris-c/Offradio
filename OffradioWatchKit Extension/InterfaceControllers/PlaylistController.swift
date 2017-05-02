//
//  PlaylistController.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import SwiftyJSON

class PlaylistController: WKInterfaceController {
    
    let communication = OffradioWatchCommunication()
    
    @IBOutlet var playlistTable: WKInterfaceTable!
    fileprivate var songs: [Song] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func didAppear() {
        super.didAppear()
        self.playlistTable.setNumberOfRows(self.songs.count, withRowType: "playlistRow")
        
        self.communication.getPlaylist { data in
            if let songs = data["data"] as? [[String: Any]] {
                for songData in songs {
                    let json = JSON(songData)
                    let song = Song(with: json)
                    self.songs.append(song)
                    self.populateRows()
                }
            }
        }
        
    }
    
    fileprivate func populateRows() {
        self.playlistTable.setNumberOfRows(self.songs.count, withRowType: "playlistRow")
        for (index,song) in songs.enumerated() {
            if let cell = self.playlistTable.rowController(at: index) as? PlaylistTableViewRow {
                cell.songTitle.setText(song.title)
                cell.timeLabel.setText(song.time)
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
}
