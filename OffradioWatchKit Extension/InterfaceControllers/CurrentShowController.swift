//
//  CurrentShowController.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import Kingfisher

class CurrentShowController: WKInterfaceController {
    
    let communication = OffradioWatchCommunication()
    
    @IBOutlet var producerName: WKInterfaceLabel!
    @IBOutlet var producerArtwork: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.producerName.setText("#epicmusiconly")
    }
    
    override func didAppear() {
        super.didAppear()
        
        communication.getCurrentShow { [weak self] (info) in
            if let data = info["data"] as? [String: Any] {
                let show = Show.from(dictionary: data)
                DispatchQueue.main.async {
                    if show.name.isEmpty {
                        self?.producerName.setText(show.body)
                    } else {
                        self?.producerName.setText(show.name)                        
                    }
                    if let url = URL(string: show.photo) {
                        self?.loadProducerArtwork(url: url)
                    }
                }
            }
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    fileprivate func loadProducerArtwork(url: URL) {
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            if case let .success(data) = result {
                self?.producerArtwork.setImage(data.image)
            }
        }
    }
    
}
