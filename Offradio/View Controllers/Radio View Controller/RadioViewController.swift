//
//  RadioViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import MediaPlayer
import RxSwift
import RxCocoa

final class RadioViewController: UIViewController, TabBarItemProtocol {
    
    @IBOutlet weak var playerCircleContainer: PlayerCircleContainerView!
    
    fileprivate final var turnYourRadioOffLabel: UILabel!
    fileprivate final var nowPlayingButton: NowPlayingButton!
    
    fileprivate final let disposeBag: DisposeBag = DisposeBag()
    fileprivate final var viewModel: RadioViewModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Offradio Player"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
        self.viewModel = RadioViewModel()

        self.playerCircleContainer.setupViews()
        self.playerCircleContainer.rearrangeViews()
        
        self.turnYourRadioOffLabel = UILabel()
        self.turnYourRadioOffLabel.font = UIFont.leagueGothicItalic(withSize: 26)
        self.turnYourRadioOffLabel.textColor = UIColor.white
        self.turnYourRadioOffLabel.text = "TURN YOUR RADIO OFF"
        self.turnYourRadioOffLabel.numberOfLines = 1
        self.view.addSubview(self.turnYourRadioOffLabel)
        
        self.nowPlayingButton = NowPlayingButton(frame: .zero)
        self.nowPlayingButton.alpha = 0.0
        self.view.addSubview(self.nowPlayingButton)
        
        self.nowPlayingButton.rx.tap.asObservable().subscribe(onNext: { _ in
            //
        }).addDisposableTo(disposeBag)
        
        self.playerCircleContainer.switched.bindTo(viewModel.toggleRadio).addDisposableTo(disposeBag)
        viewModel.isBuffering.asObservable().bindTo(self.playerCircleContainer.buffering).addDisposableTo(disposeBag)
        viewModel.isPlaying.asObservable().bindTo(self.playerCircleContainer.playing).addDisposableTo(disposeBag)
        
        viewModel.isPlaying.asObservable().subscribe(onNext: { [weak self] isPlaying in
            self?.fadeNowPlayingButton(shouldFadeIn: isPlaying)
        }).addDisposableTo(disposeBag)
     
        viewModel.nowPlaying.asObservable()
            .map { $0.current.title }
            .bindTo(self.nowPlayingButton.title)
            .addDisposableTo(disposeBag)
        
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
    
    fileprivate func fadeNowPlayingButton(shouldFadeIn: Bool) {
        let targetAlpha: CGFloat = shouldFadeIn ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3) { 
            self.nowPlayingButton.alpha = targetAlpha
        }
    }
    
    fileprivate func showPlaylistViewController() {
        self.hideLabelOnBackButton()
        let playlistViewController = PlaylistViewController()
        self.navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let effectiveHeight = self.view.frame.height - self.playerCircleContainer.frame.maxY
        
        self.turnYourRadioOffLabel.sizeToFit()
        let width = self.turnYourRadioOffLabel.frame.width + 5
        self.turnYourRadioOffLabel.frame.size.width = width
        self.turnYourRadioOffLabel.frame.origin.y = self.playerCircleContainer.frame.maxY + ((effectiveHeight - self.turnYourRadioOffLabel.frame.height) * 0.5)
        self.turnYourRadioOffLabel.center.x = self.view.center.x
        
        self.nowPlayingButton.sizeToFit()
        self.nowPlayingButton.frame.origin.y = self.playerCircleContainer.frame.maxY + ((effectiveHeight - self.nowPlayingButton.frame.height) * 0.5)
        self.nowPlayingButton.center.x = self.view.center.x
    }
    
}

// MARK: TabBarItemProtocol
extension RadioViewController {
    
    func defaultTabBarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "", image: #imageLiteral(resourceName: "listen"), tag: TabIdentifier.listen.rawValue)
        item.selectedImage = #imageLiteral(resourceName: "listen-selected")
        return item
    }
    
}
