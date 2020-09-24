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
    fileprivate final let offradio: Offradio
    fileprivate final let favouritesDataLayer: PlaylistFavouritesLayer

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

    }

    func enableCommands() {
        self.enablePlayPauseCommand()
        self.enableLikeDislikeCommand()
        self.sharedCenter.playCommand.isEnabled = true
        self.sharedCenter.pauseCommand.isEnabled = true
        self.sharedCenter.likeCommand.isEnabled = true
        self.sharedCenter.dislikeCommand.isEnabled = true
        self.sharedCenter.togglePlayPauseCommand.isEnabled = true
    }

    func disableCommands() {
        self.sharedCenter.playCommand.removeTarget(self)
        self.sharedCenter.playCommand.isEnabled = false
        self.sharedCenter.pauseCommand.removeTarget(self)
        self.sharedCenter.pauseCommand.isEnabled = false
        self.sharedCenter.likeCommand.removeTarget(self)
        self.sharedCenter.likeCommand.isEnabled = false
        self.sharedCenter.dislikeCommand.removeTarget(self)
        self.sharedCenter.dislikeCommand.isEnabled = false
        self.sharedCenter.togglePlayPauseCommand.removeTarget(self)
        self.sharedCenter.togglePlayPauseCommand.isEnabled = false
    }

    fileprivate func enablePlayPauseCommand() {
        self.sharedCenter.playCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.offradio.start()
            return .success
        }
        self.sharedCenter.pauseCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.offradio.stop()
            return .success
        }
        self.sharedCenter.togglePlayPauseCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.offradio.toggleRadio()
            return .success
        }
    }

    fileprivate func enableLikeDislikeCommand() {
        self.sharedCenter.likeCommand.localizedTitle = "Add Favourite"
        self.sharedCenter.likeCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let self = self else { return .noSuchContent }
            let song = self.offradio.metadata.currentTrack.value
            if !self.favouritesDataLayer.isFavourite(for: song.artist,
                                                     songTitle: song.name) {
                try? self.favouritesDataLayer.createFavourite(with: song.toPlaylistSong())
                return .success
            }
            return .noSuchContent
        }
        self.sharedCenter.dislikeCommand.localizedTitle = "Remove Favourite"
        self.sharedCenter.dislikeCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            guard let self = self else { return .noSuchContent }
            let song = self.offradio.metadata.currentTrack.value
            try? self.favouritesDataLayer.deleteFavourite(for: song.artist,
                                                          songTitle: song.name)
            return .success
        }
    }
    
}
