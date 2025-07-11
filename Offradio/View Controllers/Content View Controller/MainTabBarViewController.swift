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
}

final class MainTabBarViewController: UITabBarController {

    private let offradio: Offradio

    init(with dependencies: CoreDependencies, andViewModel model: RadioViewModel) {
        self.offradio = dependencies.offradio
        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = UIColor.white
        self.setupTabBarAppearance()

        let radioViewController = offradioViewController(with: self.offradio, andViewModel: model)
        self.viewControllers = [scheduleViewController(networkService: dependencies.networkService),
                                radioViewController,
                                contactViewController()]

        self.selectedIndex = TabIdentifier.listen.rawValue

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    final fileprivate func setupTabBarAppearance() {

        self.tabBar.shadowImage = UIImage(named: "tabbar-shaddow")
        self.tabBar.backgroundImage = UIImage(named: "tabbar-background")

        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
        self.tabBar.isTranslucent = false

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    // MARK: View Controllers

    fileprivate final func scheduleViewController(networkService: OffradioNetworkService) -> UINavigationController {
        let viewModel = ScheduleViewModel(networkService: networkService)
        let rootViewController = ScheduleViewController(viewModel: viewModel)
        rootViewController.tabBarItem = rootViewController.defaultTabBarItem()
        let scheduleNavigationController = navigationController(withRootViewController: rootViewController)
        return scheduleNavigationController
    }

    fileprivate final func offradioViewController(with radio: Offradio, andViewModel model: RadioViewModel) -> UINavigationController {
        let radioViewController = RadioViewController.createFromStoryboard()
        radioViewController.offradio = radio
        radioViewController.viewModel = model

        radioViewController.tabBarItem = radioViewController.defaultTabBarItem()
        let radioNavigationController = navigationController(withRootViewController: radioViewController)

        return radioNavigationController
    }

    fileprivate final func contactViewController() -> UINavigationController {
        let rootViewController = ContactViewController()
        rootViewController.tabBarItem = rootViewController.defaultTabBarItem()
        let contactNavigationController = navigationController(withRootViewController: rootViewController)
        return contactNavigationController

    }

    fileprivate final func navigationController(withRootViewController viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
