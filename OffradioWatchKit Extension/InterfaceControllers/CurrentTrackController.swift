//
//  NowPlayingController.swift
//  Offradio
//
//  Created by Dimitris C. on 28/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import WatchKit
import Kingfisher
import WatchConnectivity
import RxSwift
import RxCocoa

class CurrentTrackController: WKInterfaceController {
    let disposeBag = DisposeBag()
    let communication = OffradioWatchCommunication()
    
    @IBOutlet var albumArtwork: WKInterfaceGroup!
    @IBOutlet var songTitle: WKInterfaceLabel!
    @IBOutlet var favouriteIcon: WKInterfaceImage!
    
    fileprivate var currentTrack = BehaviorRelay<CurrentTrack>(value: CurrentTrack.empty)
    fileprivate var isFavourite: Bool = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        songTitle.setText("Turn Your Radio Off")
        self.currentTrack.asObservable()
            .subscribe(onNext: { [weak self] track in
                self?.checkFavouriteStatus(with: track)
        }).disposed(by: disposeBag)
        
        OffradioWatchSession.shared.currentTrack.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] track in
                self?.currentTrack.accept(track)
                DispatchQueue.main.async {
                    self?.songTitle.setText(track.title)
                    if let url = URL(string: track.image) {
                        self?.loadAlbumArtwork(url: url)
                    }
                }
            }).disposed(by: disposeBag)
        
    }

    override func didAppear() {
        super.didAppear()
        communication.getCurrentTrack { [weak self] info in
            if let data = info["data"] as? [String: Any] {
                let track = CurrentTrack.from(dictionary: data)
                self?.currentTrack.accept(track)
                DispatchQueue.main.async {
                    self?.songTitle.setText(track.title)
                    if let url = URL(string: track.image) {
                        self?.loadAlbumArtwork(url: url)
                    }
                }
            }
        }
    }
    
    fileprivate func checkFavouriteStatus(with track: CurrentTrack) {
        communication.getIsFavourite(for: track) { [weak self] replyInfo in
            let data = replyInfo["data"] as? [String: Any]
            let isFavourite: Bool = data?["isFavourite"] as? Bool ?? false
            self?.adjustFavouriteIcon(with: isFavourite)
        }
    }

    @IBAction func toggleFavourite() {
        self.communication.toggleFavourite(for: self.currentTrack.value) { [weak self] replyInfo in
            if let data = replyInfo["data"] as? [String: Any] {
                let favourite = data["isFavourite"] as? Bool ?? false
                self?.adjustFavouriteIcon(with: favourite)
            }
        }
    }
    
    fileprivate func adjustFavouriteIcon(with status: Bool) {
        if status {
            self.favouriteIcon.setImageNamed("favourite-button-icon-added")
        } else {
            self.favouriteIcon.setImageNamed("favourite-button-icon")
        }
    }
    
    fileprivate func loadAlbumArtwork(url: URL) {
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            if case let .success(data) = result {
                self?.albumArtwork.setBackgroundImage(data.image)
            }
        }
    }
}
