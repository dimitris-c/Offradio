//
//  CurrentTrackView.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage

final class CurrentTrackView: UIView {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var albumArtwork: UIImageView!
    
    fileprivate var bottomViewsArranger = VerticalArranger()
    fileprivate var bottomViewsContainer: UIView!
    fileprivate var nowPlayingIcon: UIImageView!
    fileprivate var artistLabel: UILabel!
    fileprivate var songTitleLabel: UILabel!
    fileprivate var bottomGradient: UIView!
    
    fileprivate var shareButton: UIButton!
    fileprivate var favouriteButton: UIButton!
    
    init(with currentTrack: Driver<CurrentTrack>) {
        super.init(frame: .zero)
        
        self.albumArtwork = UIImageView(image: #imageLiteral(resourceName: "artwork-image-placeholder"))
        self.albumArtwork.clipsToBounds = true
        self.albumArtwork.contentMode = .scaleAspectFill
        self.addSubview(self.albumArtwork)
        
        self.supplySubviews()
        
        currentTrack.asObservable()
            .map { $0.image }
            .subscribe(onNext: { [weak self] image in
                if let url = URL(string: image) {
                    self?.albumArtwork.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "artwork-image-placeholder"))
                }
            })
            .addDisposableTo(disposeBag)
        
        currentTrack.asObservable()
            .map{ try? $0.artist.convertHTMLEntities() ?? "" }
            .startWith("Offradio")
            .bindTo(artistLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        currentTrack.asObservable()
            .map{ try? $0.track.convertHTMLEntities() ?? "" }
            .startWith("Turn Your Radio Off")
            .bindTo(songTitleLabel.rx.text)
            .addDisposableTo(disposeBag)
        
    }
    
    fileprivate func supplySubviews() {
        self.shareButton = UIButton(type: .custom)
        self.shareButton.setBackgroundImage(#imageLiteral(resourceName: "share-track-icon"), for: .normal)
        self.shareButton.setBackgroundImage(#imageLiteral(resourceName: "share-track-icon-tapped"), for: .highlighted)
        self.shareButton.setBackgroundImage(#imageLiteral(resourceName: "share-track-icon-tapped"), for: .selected)
        self.addSubview(self.shareButton)
        
        
        self.bottomViewsContainer = UIView()
        self.addSubview(self.bottomViewsContainer)
        
        self.nowPlayingIcon = UIImageView(image: #imageLiteral(resourceName: "nowplaying-hastag"))
        self.bottomViewsContainer.addSubview(self.nowPlayingIcon)
        
        self.artistLabel = UILabel(frame: .zero)
        self.artistLabel.textColor = UIColor.white
        self.artistLabel.font = UIFont.leagueGothicItalic(withSize: CGFloat.deviceValue(iPhone: 29, iPad: 38))
        self.artistLabel.textAlignment = .left
        self.artistLabel.lineBreakMode = .byWordWrapping
        self.artistLabel.numberOfLines = 2
        self.artistLabel.text = "Offradio"
        self.bottomViewsContainer.addSubview(self.artistLabel)
        
        self.songTitleLabel = UILabel(frame: .zero)
        self.songTitleLabel.textColor = UIColor.white
        self.songTitleLabel.font = UIFont.leagueGothicItalic(withSize: CGFloat.deviceValue(iPhone: 24, iPad: 34))
        self.songTitleLabel.textAlignment = .left
        self.songTitleLabel.lineBreakMode = .byWordWrapping
        self.songTitleLabel.numberOfLines = 3
        self.songTitleLabel.text = "Turn Your Radio Off"
        self.bottomViewsContainer.addSubview(self.songTitleLabel)
        
        bottomViewsArranger.add(object: SizeObject(type: .flexible, view: self.nowPlayingIcon))
        bottomViewsArranger.add(object: SizeObject(type: .flexible, view: self.artistLabel))
        bottomViewsArranger.add(object: SizeObject(type: .flexible, view: self.songTitleLabel))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.albumArtwork.frame = self.bounds
        
        self.shareButton.sizeToFit()
        self.shareButton.frame.origin = CGPoint(x: self.bounds.width - self.shareButton.frame.width - 10,
                                                y: 10)
        
        self.bottomViewsArranger.resizeToFit()
        
        let padding: CGFloat = 20
        bottomViewsContainer.frame.origin.x     = padding
        bottomViewsContainer.frame.size.width   = self.bounds.width - padding * 2
        self.artistLabel.frame.size.width       = bottomViewsContainer.frame.size.width
        self.songTitleLabel.frame.size.width    = bottomViewsContainer.frame.size.width
        
        let height = self.bottomViewsArranger.arrange()
        
        bottomViewsContainer.frame.origin.y     = self.bounds.maxY - height - padding
        bottomViewsContainer.frame.size.height  = height
    }
    
    fileprivate func updateSong(with track: CurrentTrack) {
        let animations = {
            self.nowPlayingIcon.frame.origin.y   = self.bottomViewsContainer.frame.height
            self.artistLabel.frame.origin.y      = self.bottomViewsContainer.frame.height
            self.songTitleLabel.frame.origin.y   = self.bottomViewsContainer.frame.height
        }
        
        let completion: (Bool) -> () = { completed in
            self.artistLabel.text = track.artist
            self.songTitleLabel.text = track.track
            self.showLabelsAnimated()
        }
        
        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: animations,
                       completion: completion)
        
    }
    
    fileprivate func showLabelsAnimated() {
        
        UIView.animate(withDuration: 0.55, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .curveEaseOut,
                       animations: { 
                        self.layoutSubviews()
        },
                       completion: nil)
        
    }
    
}
