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

    private let turnYourRadioOffLabel = UILabel()
    private let nowPlayingButton: NowPlayingButton
    
    required init?(coder aDecoder: NSCoder) {
        self.nowPlayingButton = NowPlayingButton(frame: .zero)
        super.init(coder: aDecoder)
        self.title = "Offradio Player"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightBlack

        #if Debug
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Debug", style: .done, target: self, action: #selector(showDebugMenu))
        #endif

        self.playerCircleContainer.setupViews()
        self.playerCircleContainer.rearrangeViews()

        self.turnYourRadioOffLabel.font = UIFont.leagueGothicItalic(withSize: CGFloat.deviceValue(iPhone: 26, iPad: 36))
        self.turnYourRadioOffLabel.textColor = UIColor.white
        self.turnYourRadioOffLabel.text = "TURN YOUR RADIO OFF"
        self.turnYourRadioOffLabel.numberOfLines = 1
        self.scrollView.addSubview(self.turnYourRadioOffLabel)

        
        self.nowPlayingButton.alpha = 0.0
        self.scrollView.addSubview(self.nowPlayingButton)

        self.registerForPreviewing(with: self, sourceView: self.nowPlayingButton)

        self.bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.nowPlayingButton.startScrolling()
    }

    func showPlaylistViewController() {
        self.hideLabelOnBackButton()
        let playlistViewController = PlaylistViewController()
        self.navigationController?.pushViewController(playlistViewController, animated: true)
    }

    final private func bindViewModel() {
        self.nowPlayingButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.showNowPlayingViewController(with: strongSelf.offradio.metadata)
        }).disposed(by: disposeBag)

        self.playerCircleContainer.switched.bind(to: viewModel.toggleRadioTriggered).disposed(by: disposeBag)
        viewModel.isBuffering.asObservable().bind(to: self.playerCircleContainer.buffering).disposed(by: disposeBag)
        viewModel.isPlaying.asObservable().bind(to: self.playerCircleContainer.playing).disposed(by: disposeBag)

        viewModel.isPlaying.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isPlaying in
                self?.fadeNowPlayingButton(shouldFadeIn: isPlaying)
            }).disposed(by: disposeBag)

        viewModel.nowPlaying
            .map { $0.track.title }
            .drive(self.nowPlayingButton.rx.title)
            .disposed(by: disposeBag)

        let playlistButton = UIButton(type: .custom)
        playlistButton.setBackgroundImage(#imageLiteral(resourceName: "playlist-menu-bar-icon"), for: .normal)
        playlistButton.setBackgroundImage(#imageLiteral(resourceName: "playlist-menu-bar-icon-tapped"), for: .highlighted)
        playlistButton.sizeToFit()
        let barButton = UIBarButtonItem(customView: playlistButton)
        self.navigationItem.rightBarButtonItem = barButton

        playlistButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.showPlaylistViewController()
        }).disposed(by: disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if DeviceType.iPhone5 {
            self.playerCircleContainerTopConstraint.constant = 30
        } else if DeviceType.iPhone4OrLess {
            self.playerCircleContainerTopConstraint.constant = 20
        }
        
        if DeviceType.iPad {
            let orientation = UIDevice.current.orientation
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                self.playerCircleContainerTopConstraint.constant = 60
            } else {
                self.playerCircleContainerTopConstraint.constant = 155
            }
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

    @objc fileprivate func showDebugMenu() {
        let vc = DebugViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }

    fileprivate func fadeNowPlayingButton(shouldFadeIn: Bool) {
        let targetAlpha: CGFloat = shouldFadeIn ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3) {
            self.nowPlayingButton.alpha = targetAlpha
        }
    }

    fileprivate func showNowPlayingViewController(with offradioMetadata: RadioMetadata) {
        self.hideLabelOnBackButton()
        let nowPlayingViewController = NowPlayingViewController(with: offradioMetadata)
        self.navigationController?.pushViewController(nowPlayingViewController, animated: true)
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
