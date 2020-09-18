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
import RxCocoa

class OffradioWatchSession: NSObject, WCSessionDelegate {
    
    static let shared: OffradioWatchSession = OffradioWatchSession()
    
    let radioState = BehaviorRelay<RadioState>(value: .stopped)
    let currentTrack = BehaviorRelay<CurrentTrack>(value: CurrentTrack.default)
    let isFavourite = BehaviorRelay<Bool>(value: false)
    
    func activate() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if WCSession.isSupported() {
            if activationState == .activated, session.isReachable {
                session.sendMessage(["action": OffradioWatchAction.radioStatus.rawValue],
                                    replyHandler: nil,
                                    errorHandler: nil)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let actionString = message["action"] as? String else { return }
        guard let action = OffradioWatchAction(rawValue: actionString) else { return }
        switch action {
        case .radioStatus:
            let rawStatus = message["data"] as? Int ?? 0
            radioState.accept(RadioState(rawValue: rawStatus) ?? .stopped)
            break
        case .toggleRadio:
            let shouldToggleRadio: Bool = message["data"] as? Bool ?? false
            radioState.accept(shouldToggleRadio ? .playing : .stopped)
            break
        case .currentTrack:
            if let data = message["data"] as? [String: Any] {                
                let track = CurrentTrack.from(dictionary: data)
                currentTrack.accept(track)
            }
        case .favouriteStatus:
            self.isFavourite.accept(message["data"] as? Bool ?? false)
        default:
            break
        }
        
        replyHandler(["":""])
    }

}

