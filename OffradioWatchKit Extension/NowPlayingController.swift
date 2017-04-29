//
//  NowPlayingController.swift
//  Offradio
//
//  Created by Dimitris C. on 28/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import WatchConnectivity

class NowPlayingController: WKInterfaceController {
    
    let communication = OffradioWatchCommunication()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
