//
//  OffradioWatchSession.swift
//  Offradio
//
//  Created by Dimitris C. on 26/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchConnectivity

class OffradioWatchSession: NSObject, WCSessionDelegate {
    
    var radio: Offradio!
    var viewModel: RadioViewModel!
    
    init(with radio: Offradio, andViewModel model: RadioViewModel) {
        super.init()
        self.radio = radio
        self.viewModel = model
    }
    
    func activate() {
        if WCSession.isSupported() {
            WCSession.default().delegate = self
            WCSession.default().activate()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        self.parseMessage(with: message)
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
        
        self.parseMessage(with: message, andReply: replyHandler)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    fileprivate func parseMessage(with message: [String: Any]) {
        
    }
    
    fileprivate func parseMessage(with message: [String: Any], andReply reply: @escaping ([String : Any]) -> Void) {
        print("Message \(message)")
        guard let actionString = message["action"] as? String else { return }
        guard let action = OffradioWatchAction(rawValue: actionString) else { return }
        
        switch action {
        case .toggleRadio:
            let data: Bool = message["data"] as? Bool ?? false
            self.toggleRadio(with: data)
            break
        case .radioStatus:
            self.radioStatus(withReply: { (state) in
                reply(["action": OffradioWatchAction.radioStatus.rawValue, "data": state.rawValue])
            })
            break
        default:
            break
        }
        

    }
    
    fileprivate func toggleRadio(with status: Bool) {
        if status {
            self.radio.start()
        } else {
            self.radio.stop()
        }
    }
    
    fileprivate func radioStatus(withReply reply: (RadioState) -> Void) {
        let status = self.radio.status.isPlaying ? RadioState.playing : RadioState.stopped
        reply(status)
    }
}
