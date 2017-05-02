//
//  CurrentShowController.swift
//  Offradio
//
//  Created by Dimitris C. on 29/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import SDWebImage
import SwiftyJSON

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
        
    }
    
    override func didAppear() {
        super.didAppear()
        
        communication.getCurrentShow { (info) in
            if let data = info["data"] as? [String: Any] {
                let json = JSON(data)
                let show = Show(json: json)
                DispatchQueue.main.async { [weak self] in
                    self?.producerName.setText(show.name)
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
        SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.init(rawValue: 0), progress: nil) { (image, data, error, cacheType, finished, url) in
            self.producerArtwork.setImage(image)
        }
    }
    
}
