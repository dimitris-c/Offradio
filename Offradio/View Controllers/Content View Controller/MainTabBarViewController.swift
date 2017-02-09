//
//  MainTabBarViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

// This defines the appropriate tab on each viewcontroller for the MainTabBarViewController
public enum TabIdentifier: Int {
    case schedule = 0
    case listen = 1
    case contact = 2
    
    static let allValues = [schedule, listen, contact]
}

final class MainTabBarViewController: UITabBarController {
    
    var button: UIButton?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.viewControllers = defaultViewControllers()
        
        self.view.backgroundColor = UIColor.white
        self.setupTabBarAppearance()
        
        self.selectedIndex = TabIdentifier.listen.rawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final fileprivate func setupTabBarAppearance() {

        self.tabBar.shadowImage = UIImage(named: "tabbar-shaddow")
        self.tabBar.backgroundImage = UIImage(named: "tabbar-background")
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.isTranslucent = false
    }

    fileprivate final func defaultViewControllers() -> [UIViewController] {
        return [scheduleViewController(),
                offradioViewController(),
                contactViewController()]
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: View Controllers
    
    fileprivate final func scheduleViewController() -> UINavigationController {
        let rootViewController = ScheduleViewController()
        rootViewController.tabBarItem = rootViewController.defaultTabBarItem()
        let scheduleNavigationController = navigationController(withRootViewController: rootViewController)
        return scheduleNavigationController
    }
    
    fileprivate final func offradioViewController() -> UINavigationController {
        let radioViewController = RadioViewController.createFromStoryboard()
        radioViewController.tabBarItem = radioViewController.defaultTabBarItem()
        let searchNavigationController = navigationController(withRootViewController: radioViewController)
        
        return searchNavigationController
    }
    
    fileprivate final func contactViewController() -> UINavigationController {
        let rootViewController = ContactViewController.createFromStoryboard()
        rootViewController.tabBarItem = rootViewController.defaultTabBarItem()
        let contactNavigationController = navigationController(withRootViewController: rootViewController)
        return contactNavigationController

    }
 
    fileprivate final func navigationController(withRootViewController viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
