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
    case schedule
    case listen
    case contact
    
    static let allValues = [schedule, listen, contact]
}

final class MainTabBarViewController: UITabBarController {
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.viewControllers = defaultViewControllers()
        self.tabBarController?.view.backgroundColor = UIColor.white
        self.setupTabBarAppearance()
        self.tabBarController?.selectedIndex = TabIdentifier.listen.rawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final fileprivate func setupTabBarAppearance() {
        
        self.tabBar.tintColor = UIColor(red:0.19, green:0.23, blue:0.29, alpha:1.00)
        
        let normalAttributes = [NSForegroundColorAttributeName: UIColor(red:0.64, green:0.67, blue:0.72, alpha:1.00),
                                NSFontAttributeName: UIFont.defaultLight(withSize: 11)]
        let selectedAttributes = [NSForegroundColorAttributeName: UIColor(red:0.19, green:0.23, blue:0.29, alpha:1.00),
                                  NSFontAttributeName: UIFont.defaultLight(withSize: 11)]
        self.tabBar.isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: UIControlState.selected)
    }
    
    fileprivate final func defaultViewControllers() -> [UIViewController] {
        return [scheduleViewController(),
                offradioViewController(),
                contactViewController()]
    }
    
    fileprivate final func scheduleViewController() -> UINavigationController {
        
        return UINavigationController()
    }
    
    fileprivate final func offradioViewController() -> UINavigationController {
        let radioViewController = RadioViewController()
        radioViewController.tabBarItem = radioViewController.defaultTabBarItem()
        let searchNavigationController = navigationController(withRootViewController: radioViewController)
        
        return searchNavigationController
    }
    
    fileprivate final func contactViewController() -> UINavigationController {
        return UINavigationController()
    }
 
    fileprivate final func navigationController(withRootViewController viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
