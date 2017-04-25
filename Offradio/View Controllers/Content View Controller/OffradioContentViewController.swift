//
//  OffradioContentViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import MediaPlayer

public protocol TabBarItemProtocol {
    func defaultTabBarItem() -> UITabBarItem
}

final class OffradioContentViewController: UIViewController {
    
    var tabBarViewContainer:UIView?
    var mainTabBarController:MainTabBarViewController?
    
    fileprivate var offradio: Offradio!
    fileprivate var commandCenter: OffradioCommandCenter!
    fileprivate var nowPlayingInfoCenter: OffradioNowPlayingInfoCenter!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.offradio = Offradio()
        self.commandCenter = OffradioCommandCenter(with: self.offradio)
        self.nowPlayingInfoCenter = OffradioNowPlayingInfoCenter(with: self.offradio)
        self.commandCenter.isEnabled = true
        
        self.mainTabBarController = MainTabBarViewController(with: self.offradio)
        
        if let mainTabBarController = mainTabBarController {
            self.addContainerViewController(mainTabBarController)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPlaylist() {
        self.mainTabBarController?.selectedIndex = TabIdentifier.listen.rawValue
        let radioViewController = getOffradioViewController()
        radioViewController?.showPlaylistViewController()
    }
    
    func turnRadioOn() {
        self.mainTabBarController?.selectedIndex = TabIdentifier.listen.rawValue
        delayMain(0.2) { [weak self] in
            self?.offradio.start()
        }
    }
    
    func showSchedule() {
        self.mainTabBarController?.selectedIndex = TabIdentifier.schedule.rawValue
    }
    
    fileprivate func getOffradioViewController() -> RadioViewController? {
        let radioNavVC = self.mainTabBarController?.selectedViewController as? UINavigationController
        return radioNavVC?.visibleViewController as? RadioViewController
    }
    
    override var shouldAutorotate: Bool {
        return mainTabBarController?.shouldAutorotate ?? false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return mainTabBarController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return mainTabBarController
    }
    
    override open var childViewControllerForStatusBarHidden: UIViewController? {
        return mainTabBarController
    }
    
}
