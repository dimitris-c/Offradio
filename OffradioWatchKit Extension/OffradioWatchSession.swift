//
//  OffradioWatchSession.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity

class OffradioWatchSession: NSObject, WCSessionDelegate {
    
    static let shared: OffradioWatchSession = OffradioWatchSession()
    
    var radioState: RadioState = .stopped
    
    func activate() {
        if WCSession.isSupported() {
            WCSession.default().delegate = self
            WCSession.default().activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("\(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let actionString = message["action"] as? String else { return }
        guard let action = OffradioWatchAction(rawValue: actionString) else { return }
        if action == .toggleRadio {
            let shouldToggleRadio: Bool = message["data"] as? Bool ?? false
            radioState = shouldToggleRadio ? .playing : .stopped
        }
        else if action == .radioStatus {
            let rawStatus = message["data"] as? Int ?? 0
            radioState = RadioState(rawValue: rawStatus) ?? .stopped
        }
        replyHandler(["":""])
    }

}

