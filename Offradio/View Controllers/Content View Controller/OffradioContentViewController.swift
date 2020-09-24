//
//  OffradioContentViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import MediaPlayer

enum ContentState {
    case loading(title: String?)
    case render(UIViewController)
}

public protocol TabBarItemProtocol {
    func defaultTabBarItem() -> UITabBarItem
}

protocol RootContentDisplayable {
    func transition(to state: ContentState)
}

extension RootContentDisplayable {
    var viewController: UIViewController? {
        return self as? UIViewController
    }
}


final class OffradioContentViewController: UIViewController, RootContentDisplayable {
    private var state: ContentState?
    private var shownViewController: UIViewController?
    
    var tabBarViewContainer: UIView?
    var mainTabBarController: MainTabBarViewController?

    fileprivate var offradio: Offradio!
    fileprivate var offradioViewModel: RadioViewModel!
    fileprivate var commandCenter: OffradioCommandCenter!
    fileprivate var nowPlayingInfoCenter: OffradioNowPlayingInfoCenter!

    init(with dependencies: CoreDependencies, andViewModel model: RadioViewModel) {
        super.init(nibName: nil, bundle: nil)

        self.offradio = dependencies.offradio
        self.offradioViewModel = model
        self.commandCenter = OffradioCommandCenter(with: self.offradio)
        self.nowPlayingInfoCenter = OffradioNowPlayingInfoCenter(with: self.offradio)
        self.commandCenter.isEnabled = true

        self.mainTabBarController = MainTabBarViewController(with: dependencies, andViewModel: self.offradioViewModel)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        self.setNeedsStatusBarAppearanceUpdate()
        
        if let mainTabBarController = mainTabBarController {
            self.addContainerViewController(mainTabBarController)
        }
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

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return mainTabBarController?.supportedInterfaceOrientations ?? .portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    func transition(to state: ContentState) {
        let vc = viewController(for: state)
        self.display(rootViewController: vc)
        shownViewController = vc
        self.state = state
    }
    
    private func display(rootViewController: UIViewController) {
        if let current = shownViewController {
            current.willMove(toParent: nil)
            self.addChild(rootViewController)
            rootViewController.view.frame = self.view.bounds
            rootViewController.view.alpha = 0.0
            self.transition(from: current,
                            to: rootViewController,
                            duration: 0.2,
                            options: [.curveEaseInOut],
                            animations: {
                                rootViewController.view.alpha = 1.0
            }, completion: { (_) in
                current.removeFromParent()
                rootViewController.didMove(toParent: self)
            })
        } else {
            self.addContainerViewController(rootViewController)
        }

        self.setNeedsStatusBarAppearanceUpdate()
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }
}


private extension OffradioContentViewController {
    func viewController(for state: ContentState) -> UIViewController {
        switch state {
        case .loading(let title):
            return ContentLoadingViewController(with: title)
        case .render(let viewController):
            return viewController
        }
    }
}
