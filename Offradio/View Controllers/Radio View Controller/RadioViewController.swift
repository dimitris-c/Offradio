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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playerCircleContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerCircleContainer: PlayerCircleContainerView!
    
    fileprivate final let disposeBag: DisposeBag = DisposeBag()
    
    final var offradio: Offradio!
    final var viewModel: RadioViewModel!
    
    fileprivate final var turnYourRadioOffLabel: UILabel!
    fileprivate final var nowPlayingButton: NowPlayingButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Offradio Player"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
        self.playerCircleContainer.setupViews()
        self.playerCircleContainer.rearrangeViews()
        
        self.turnYourRadioOffLabel = UILabel()
        self.turnYourRadioOffLabel.font = UIFont.leagueGothicItalic(withSize: CGFloat.deviceValue(iPhone: 26, iPad: 36))
        self.turnYourRadioOffLabel.textColor = UIColor.white
        self.turnYourRadioOffLabel.text = "TURN YOUR RADIO OFF"
        self.turnYourRadioOffLabel.numberOfLines = 1
        self.scrollView.addSubview(self.turnYourRadioOffLabel)
        
        self.nowPlayingButton = NowPlayingButton(frame: .zero)
        self.nowPlayingButton.alpha = 1.0
        self.scrollView.addSubview(self.nowPlayingButton)
        
        self.registerForPreviewing(with: self, sourceView: self.nowPlayingButton)
        
        self.nowPlayingButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.showNowPlayingViewController(with: strongSelf.offradio.metadata)
        }).addDisposableTo(disposeBag)
        
        self.playerCircleContainer.switched.bind(to: viewModel.toggleRadio).addDisposableTo(disposeBag)
        viewModel.isBuffering.asObservable().bind(to: self.playerCircleContainer.buffering).addDisposableTo(disposeBag)
        viewModel.isPlaying.asObservable().bind(to: self.playerCircleContainer.playing).addDisposableTo(disposeBag)

        viewModel.isPlaying.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isPlaying in
                self?.fadeNowPlayingButton(shouldFadeIn: isPlaying)
        }).addDisposableTo(disposeBag)
     
        viewModel.nowPlaying.asObservable()
            .map { $0.current.title }
            .bind(to: self.nowPlayingButton.title)
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
    
    func showPlaylistViewController() {
        self.hideLabelOnBackButton()
        let playlistViewController = PlaylistViewController()
        self.navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
    fileprivate func showNowPlayingViewController(with offradioMetadata: OffradioMetadata) {
        self.hideLabelOnBackButton()
        let nowPlayingViewController = NowPlayingViewController(with: offradioMetadata)
        self.navigationController?.pushViewController(nowPlayingViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if DeviceType.IS_IPHONE_5 {
            self.playerCircleContainerTopConstraint.constant = 30
        }
        else if DeviceType.IS_IPHONE_4_OR_LESS {
            self.playerCircleContainerTopConstraint.constant = 20
        }
        
        let effectiveHeight = self.scrollView.frame.height - self.playerCircleContainer.frame.maxY
        
        self.turnYourRadioOffLabel.sizeToFit()
        let width = self.turnYourRadioOffLabel.frame.width + 5
        self.turnYourRadioOffLabel.frame.size.width = width
        self.turnYourRadioOffLabel.frame.origin.y = self.playerCircleContainer.frame.maxY + ((effectiveHeight - self.turnYourRadioOffLabel.frame.height) * 0.5)
        self.turnYourRadioOffLabel.center.x = self.scrollView.center.x
        
        self.nowPlayingButton.sizeToFit()
        self.nowPlayingButton.frame.origin.y = self.playerCircleContainer.frame.maxY + ((effectiveHeight - self.nowPlayingButton.frame.height) * 0.5)
        self.nowPlayingButton.center.x = self.scrollView.center.x
    }
    
}


extension RadioViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        let sourceRect = previewingContext.sourceView.convert(self.nowPlayingButton.frame, from: self.view)
        previewingContext.sourceRect = sourceRect
        let nowPlayingViewController = NowPlayingViewController(with: self.offradio.metadata)
        return nowPlayingViewController
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.hideLabelOnBackButton()
        show(viewControllerToCommit, sender: self)
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
