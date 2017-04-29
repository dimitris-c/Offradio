//
//  OffradioWatchSession.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity
import RxSwift

class OffradioWatchSession: NSObject, WCSessionDelegate {
    
    static let shared: OffradioWatchSession = OffradioWatchSession()
    
    let radioState: Variable<RadioState> = Variable<RadioState>(.stopped)
    let nowPlaying: Variable<NowPlaying> = Variable<NowPlaying>(.empty)
    
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
        switch action {
        case .radioStatus:
            let rawStatus = message["data"] as? Int ?? 0
            radioState.value = RadioState(rawValue: rawStatus) ?? .stopped
            break
        case .toggleRadio:
            let shouldToggleRadio: Bool = message["data"] as? Bool ?? false
            radioState.value = shouldToggleRadio ? .playing : .stopped
            break
        case .nowPlaying:
            break
        case .producer:
            break
        case .playlist:
            break
        }
        
        replyHandler(["":""])
    }

}

