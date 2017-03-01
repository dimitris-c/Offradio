//
//  OffradioCommandCenter.swift
//  Offradio
//
//  Created by Dimitris C. on 27/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import MediaPlayer

final class OffradioCommandCenter {
    fileprivate final let sharedCenter = MPRemoteCommandCenter.shared()
    fileprivate final var offradio: Offradio!
    fileprivate final var favouritesDataLayer: PlaylistFavouritesLayer!
    
    final var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.enableCommands()
            } else {
                self.disableCommands()
            }
        }
    }
    
    init(with radio: Offradio) {
        self.offradio = radio
        self.isEnabled = false
        
        self.favouritesDataLayer = PlaylistFavouritesLayer()
        
        self.sharedCenter.playCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            self?.offradio.start()
            return .success
        }
        self.sharedCenter.pauseCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            self?.offradio.stop()
            return .success
        }

        self.sharedCenter.likeCommand.localizedTitle = "Add Favourite"
        self.sharedCenter.likeCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let strongSelf = self else { return .noSuchContent }
            let nowPlaying = strongSelf.offradio.offradioMetadata.nowPlaying.value
            let playlistSong = nowPlaying.current.toPlaylistSong()
            if !strongSelf.favouritesDataLayer.isFavourite(for: playlistSong.artist,
                                                           songTitle: playlistSong.songTitle) {
                try? strongSelf.favouritesDataLayer.createFavourite(with: playlistSong)
                return .success
            }
            else {
                return .noSuchContent
            }
        }
        
        self.sharedCenter.dislikeCommand.localizedTitle = "Remove Favourite"
        self.sharedCenter.dislikeCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let strongSelf = self else { return .noSuchContent }
            let nowPlaying = strongSelf.offradio.offradioMetadata.nowPlaying.value
            try? strongSelf.favouritesDataLayer.deleteFavourite(for: nowPlaying.current.artist,
                                                                songTitle: nowPlaying.current.track)
            return .success
        }
        
    }
    
    func enableCommands() {
        self.sharedCenter.playCommand.isEnabled = true
        self.sharedCenter.pauseCommand.isEnabled = true
        self.sharedCenter.likeCommand.isEnabled = true
    }
    
    func disableCommands() {
        self.sharedCenter.playCommand.removeTarget(self)
        self.sharedCenter.playCommand.isEnabled = false
        self.sharedCenter.pauseCommand.removeTarget(self)
        self.sharedCenter.pauseCommand.isEnabled = false
        self.sharedCenter.likeCommand.removeTarget(self)
        self.sharedCenter.likeCommand.isEnabled = false
    }
    
}
