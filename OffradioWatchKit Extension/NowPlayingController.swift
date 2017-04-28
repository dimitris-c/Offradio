//
//  NowPlayingController.swift
//  Offradio
//
//  Created by Dimitris C. on 28/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import WatchConnectivity

class NowPlayingController: WKInterfaceController, WCSessionDelegate {
    
    let communication = OffradioWatchCommunication()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            WCSession.default().delegate = self
            WCSession.default().activate()
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("\(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        
    }
    
}
