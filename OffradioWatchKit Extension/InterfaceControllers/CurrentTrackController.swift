//
//  NowPlayingController.swift
//  Offradio
//
//  Created by Dimitris C. on 28/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import SDWebImage
import WatchConnectivity
import RxSwift
import SwiftyJSON

class CurrentTrackController: WKInterfaceController {
    let disposeBag = DisposeBag()
    let communication = OffradioWatchCommunication()
    
    @IBOutlet var albumArtwork: WKInterfaceGroup!
    @IBOutlet var songTitle: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        communication.getCurrentTrack { info in
            if let data = info["data"] as? [String: Any] {
                let json = JSON(data)
                let track = CurrentTrack(json: json)
                DispatchQueue.main.async { [weak self] in
                    self?.songTitle.setText(track.title)
                    if let url = URL(string: track.image) {
                        self?.loadAlbumArtwork(url: url)
                    }
                }
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func toggleFavourite() {
        
    }
    
    fileprivate func loadAlbumArtwork(url: URL) {
        SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.init(rawValue: 0), progress: nil) { (image, data, error, cacheType, finished, url) in
            self.albumArtwork.setBackgroundImage(image)
        }
    }
}
