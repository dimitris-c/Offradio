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
        
        self.playerCircleContainer.switched.bindTo(viewModel.toggleRadio).addDisposableTo(disposeBag)
        viewModel.isBuffering.asObservable().bindTo(self.playerCircleContainer.buffering).addDisposableTo(disposeBag)
        viewModel.isPlaying.asObservable().bindTo(self.playerCircleContainer.playing).addDisposableTo(disposeBag)
     
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
    
    fileprivate func showPlaylistViewController() {
        self.hideLabelOnBackButton()
        let playlistViewController = PlaylistViewController()
        self.navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
