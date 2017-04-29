//
//  OffradioWatchCommunication.swift
//  Offradio
//
//  Created by Dimitris C. on 26/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity

class OffradioWatchCommunication {
    
    // MARK: Both App and watch
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
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: From watch
    func getRadioStatus() {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.radioStatus.rawValue]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func getCurrentTrack(with reply: @escaping ([String: Any]) -> Void) {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.currentTrack.rawValue]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            reply(replyInfo)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCurrentShow(with reply: @escaping ([String: Any]) -> Void) {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.currentShow.rawValue]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            reply(replyInfo)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getPlaylist(with reply: @escaping ([String: Any]) -> Void) {
        guard WCSession.default().isReachable else { return }
        let message: [String: Any] = ["action": OffradioWatchAction.playlist.rawValue]
        WCSession.default().sendMessage(message, replyHandler: { replyInfo in
            reply(replyInfo)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
