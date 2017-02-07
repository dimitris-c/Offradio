//
//  OffradioContentViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

public protocol TabBarItemProtocol {
    func defaultTabBarItem() -> UITabBarItem
}

final class OffradioContentViewController: UIViewController {
    
    var tabBarViewContainer:UIView?
    var mainTabBarController:MainTabBarViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        mainTabBarController = MainTabBarViewController()
        
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
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            super.remoteControlReceived(with: nil)
            return
        }
        
        
        if event.type == UIEventType.remoteControl  {
            switch event.subtype {
            case UIEventSubtype.remoteControlTogglePlayPause:
//                if ([offradioStreamer getStreamStatus] == SRK_STATUS_STOPPED || [offradioStreamer getStreamStatus] == SRK_STATUS_PAUSED) {
//                    [Radio start];
//                    
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
//                        [[ORMobileApiClient sharedClient] getNowPlayingWithCompletion:nil errorHandler:nil];
//                        });
//                    
//                } else if ([offradioStreamer getStreamStatus] == SRK_STATUS_PLAYING) {
//                    [Radio stop];
//                }
                break;
            case UIEventSubtype.remoteControlPlay:
                
                break;
            case UIEventSubtype.remoteControlPause,
                UIEventSubtype.remoteControlStop:
                
                break
            default:
                break
            }
        } else {
            super.remoteControlReceived(with: event)
        }
        
    }
}
