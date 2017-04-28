//
//  OffradioWatchCommunication.swift
//  Offradio
//
//  Created by Dimitris C. on 26/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity

class OffradioWatchCommunication {
    
    func getRadioStatus() {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.radioStatus.rawValue]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func sendTurnRadioOn() {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.toggleRadio.rawValue,
                                      "data": true]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func sendTurnRadioOff() {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.toggleRadio.rawValue,
                                      "data": false]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            
        }) { error in
            
        }
    }
    
    func getNowPlayingInfo(with reply: (NowPlaying) -> Void) {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.nowPlaying.rawValue]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
