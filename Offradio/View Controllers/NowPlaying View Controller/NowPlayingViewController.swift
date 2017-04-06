//
//  NowPlayingViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NowPlayingViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var viewModel: NowPlayingViewModel!
    
    fileprivate var scrollView: UIScrollView!
    
    fileprivate var currentTrackViewInitialHeight: CGFloat = 0.0
    fileprivate var favouriteButton: UIButton!
    fileprivate var currentTrackView: CurrentTrackView!
    fileprivate var producerView: ProducerView!
    
    init(with radioMetadata: OffradioMetadata) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = NowPlayingViewModel(with: radioMetadata)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
        self.scrollView = UIScrollView(frame: .zero)
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        self.currentTrackView = CurrentTrackView(with: self.viewModel.currentTrack.asDriver())
        self.scrollView.addSubview(self.currentTrackView)
        
        self.favouriteButton = UIButton(type: .custom)
        self.favouriteButton.setBackgroundImage(#imageLiteral(resourceName: "player-favourite-button"), for: .normal)
        self.favouriteButton.setBackgroundImage(#imageLiteral(resourceName: "player-favourite-button-tapped"), for: .highlighted)
        self.favouriteButton.setBackgroundImage(#imageLiteral(resourceName: "player-favourite-button-tapped"), for: .selected)
        self.favouriteButton.applyShadow(with: ShadowAttributes(color: UIColor.black,
                                                                offset: CGSize(width: 0, height: 0),
                                                                radius: 3,
                                                                opacity: 0.5))
        self.currentTrackView.addSubview(self.favouriteButton)
        
        self.viewModel.favouriteTrack.asObservable()
            .bindTo(self.favouriteButton.rx.isSelected)
            .addDisposableTo(disposeBag)
        
        self.favouriteButton.rx.tap.asObservable()
            .scan(false) { state, _ in !state }
            .do(onNext: { [weak self] state in
                self?.favouriteButton.isSelected = state
            })
            .bindTo(self.viewModel.favouriteTrack)
            .addDisposableTo(disposeBag)
        
        self.producerView = ProducerView(with: self.viewModel.show.asDriver())
        self.scrollView.addSubview(self.producerView)
        
        let playlistButton = UIButton(type: .custom)
        playlistButton.setBackgroundImage(#imageLiteral(resourceName: "playlist-menu-bar-icon"), for: .normal)
        playlistButton.setBackgroundImage(#imageLiteral(resourceName: "playlist-menu-bar-icon-tapped"), for: .highlighted)
        playlistButton.sizeToFit()
        let barButton = UIBarButtonItem(customView: playlistButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        playlistButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.showPlaylistViewController()
        }).addDisposableTo(disposeBag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.checkForUpdatesInFavourite()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func showPlaylistViewController() {
        self.hideLabelOnBackButton()
        let playlistViewController = PlaylistViewController()
        self.navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.scrollView.frame = self.view.bounds
        
        self.favouriteButton.sizeToFit()
        self.favouriteButton.frame.origin = CGPoint(x: 5, y: 5)
        
        let (currentTrackRect, remainderRect) = self.view.bounds.divided(atDistance: self.view.frame.height * 0.55,
                                                                         from: .minYEdge)
        self.currentTrackView.frame = currentTrackRect.integral
        self.producerView.frame = remainderRect.integral
     
        currentTrackViewInitialHeight = self.currentTrackView.frame.size.height
    }
    
}

extension NowPlayingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        if y > 0 {
            self.currentTrackView.frame.origin.y = scrollView.contentOffset.y
            self.currentTrackView.frame.size.height = currentTrackViewInitialHeight + y
        }
    }
    
}
