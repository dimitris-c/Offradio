//
//  OffradioWatchSession.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity
import SwiftyJSON
import RxSwift

class OffradioWatchSession: NSObject, WCSessionDelegate {
    
    static let shared: OffradioWatchSession = OffradioWatchSession()
    
    let radioState: Variable<RadioState> = Variable<RadioState>(.stopped)
    let currentTrack: Variable<CurrentTrack> = Variable<CurrentTrack>(CurrentTrack.default)
    let isFavourite: Variable<Bool> = Variable<Bool>(false)
    
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
        case .currentTrack:
            if let data = message["data"] as? [String: Any] {                
                let track = CurrentTrack(json: JSON(data))
                currentTrack.value = track
            }
        case .favouriteStatus:
            self.isFavourite.value = message["data"] as? Bool ?? false
        default:
            break
        }
        
        replyHandler(["":""])
    }

}

