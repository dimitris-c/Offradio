//
//  InterfaceController.swift
//  OffradioWatchKit Extension
//
//  Created by Dimitris C. on 25/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var mainTitle: WKInterfaceLabel!
    @IBOutlet var playButtonGroup: WKInterfaceGroup!
    var radioStatus: RadioState = .stopped
    let communication = OffradioWatchCommunication()
        
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        mainTitle.setTextColor(UIColor.white)
        playButtonGroup.setBackgroundImageNamed("play-button-disabled")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        communication.getRadioStatus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func toggleRadio() {
        if radioStatus == .stopped {
            communication.sendTurnRadioOn()
        } else {
            communication.sendTurnRadioOff()
        }
    }
    
    fileprivate func adjustIcon(with status: Bool) {
        if status {
            radioStatus = .playing
            playButtonGroup.setBackgroundImageNamed("play-button-enabled")
            mainTitle.setTextColor(UIColor(red:0.98, green:0.05, blue:0.12, alpha:1.00))
        } else {
            radioStatus = .stopped
            playButtonGroup.setBackgroundImageNamed("play-button-disabled")
            mainTitle.setTextColor(UIColor.white)
        }
    }
}
