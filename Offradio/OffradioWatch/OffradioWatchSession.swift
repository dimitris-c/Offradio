//
//  OffradioWatchSession.swift
//  Offradio
//
//  Created by Dimitris C. on 26/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity

class OffradioWatchSession: NSObject, WCSessionDelegate {
    
    var contentViewController: OffradioContentViewController!
    
    init(with contentViewController: OffradioContentViewController) {
        super.init()
        self.contentViewController = contentViewController
    }
    
    func activate() {
        if WCSession.isSupported() {
            WCSession.default().delegate = self
            WCSession.default().activate()
        }
    }
 
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let application = UIApplication.shared
        var identifier = UIBackgroundTaskInvalid
        let endBlock = {
            if identifier != UIBackgroundTaskInvalid {
                application.endBackgroundTask(identifier)
            }
            identifier = UIBackgroundTaskInvalid
        }
        
        identifier = application.beginBackgroundTask(expirationHandler: endBlock)
        
        let replyHandler =  { (replyInfo: [String: Any]) in
            replyHandler(replyInfo)
            endBlock()
        }
        
        print("Message \(message)")
        
        replyHandler(["": ""])
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Handoff dictionary: \(String(describing: userActivity?.userInfo))")
    }
}
