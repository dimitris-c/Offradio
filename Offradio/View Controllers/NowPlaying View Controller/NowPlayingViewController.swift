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
import MessageUI
import FirebaseAnalytics

final class NowPlayingViewController: UIViewController {

    fileprivate let disposeBag = DisposeBag()

    fileprivate var viewModel: NowPlayingViewModel

    fileprivate var scrollView: UIScrollView!

    fileprivate var currentTrackViewInitialHeight: CGFloat = 0.0
    fileprivate var currentTrackView: CurrentTrackView!
    fileprivate var producerView: ProducerView!

    init(with radioMetadata: RadioMetadata) {
        self.viewModel = NowPlayingViewModel(with: radioMetadata)
        super.init(nibName: nil, bundle: nil)
        self.title = "Now Playing"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightBlack

        self.setupUI()
        self.setupBingings()
    }
    
    func setupUI() {
        self.scrollView = UIScrollView(frame: .zero)
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.delegate = self
        self.scrollView.contentInsetAdjustmentBehavior = .always
        self.view.addSubview(self.scrollView)
        
        self.currentTrackView = CurrentTrackView(with: self.viewModel.currentTrack)
        self.scrollView.addSubview(self.currentTrackView)
        
        self.producerView = ProducerView(with: self.viewModel.show.asDriver())
        self.scrollView.addSubview(self.producerView)
        
        let playlistButton = UIButton(type: .custom)
        playlistButton.setBackgroundImage(#imageLiteral(resourceName: "playlist-menu-bar-icon"), for: .normal)
        playlistButton.setBackgroundImage(#imageLiteral(resourceName: "playlist-menu-bar-icon-tapped"), for: .highlighted)
        playlistButton.sizeToFit()
        let barButton = UIBarButtonItem(customView: playlistButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        playlistButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPlaylistViewController()
            }).disposed(by: disposeBag)
    }
    
    func setupBingings() {
        
        self.currentTrackView.shareOn
            .asObservable()
            .withLatestFrom(viewModel.nowPlaying)
            .subscribe(onNext: { [weak self] value in
                self?.share(content: value)
            }).disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .bind(to: self.viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        self.viewModel.favouriteTrack.asObservable()
            .bind(to: self.currentTrackView.favouriteButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        self.currentTrackView.favouriteButton.rx.tap.asObservable()
            .withLatestFrom(self.viewModel.favouriteTrack)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                self?.currentTrackView.favouriteButton.isSelected = state
            })
            .bind(to: self.viewModel.markTrackAsFavourite)
            .disposed(by: disposeBag)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func share(content: NowPlaying) {
        
        let title = "I've turned my Radio OFF! #nowplaying \(content.producer.producerName) \(content.track.title) @offradio — https://www.offradio.gr"
        let url = "https://www.offradio.gr"
        let items: [Any] = [title, url]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.currentTrackView.shareButton
        activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList, .markupAsPDF, .openInIBooks, .print]
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    fileprivate func showPlaylistViewController() {
        self.hideLabelOnBackButton()
        let playlistViewController = PlaylistViewController()
        let navigationController = UINavigationController(rootViewController: playlistViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let safeBounds = CGRect(origin: .init(x: self.view.safeAreaInsets.left, y: self.view.safeAreaInsets.top), size: view.bounds.size)
        self.scrollView.frame = safeBounds

        let (currentTrackRect, remainderRect) = self.view.bounds.divided(atDistance: self.view.bounds.height * 0.55,
                                                                         from: .minYEdge)
        self.currentTrackView.frame = currentTrackRect.integral
        self.producerView.frame = remainderRect.integral

        if currentTrackViewInitialHeight == 0.0 {
            currentTrackViewInitialHeight = self.currentTrackView.frame.size.height
        }
    }

}

extension NowPlayingViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        print(y)
        if y > 0 {
            self.currentTrackView.frame.origin.y = scrollView.contentOffset.y
            self.currentTrackView.frame.size.height = currentTrackViewInitialHeight + y
        }
    }

}
