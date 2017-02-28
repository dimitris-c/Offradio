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
        
        self.sharedCenter.playCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            self?.offradio.start()
            return .success
        }
        self.sharedCenter.pauseCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            self?.offradio.stop()
            return .success
        }

    }
    
    func enableCommands() {
        self.sharedCenter.playCommand.isEnabled = true
        self.sharedCenter.pauseCommand.isEnabled = true
    }
    
    func disableCommands() {
        self.sharedCenter.playCommand.removeTarget(self)
        self.sharedCenter.playCommand.isEnabled = false
        self.sharedCenter.pauseCommand.removeTarget(self)
        self.sharedCenter.pauseCommand.isEnabled = false
    }
    
}
