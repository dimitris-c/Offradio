//
//  AppCoordinator.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    
    private let dependencies: CoreDependencies
    private let offradio: Offradio
    private let watchCommunication: OffradioWatchCommunication
    private let radioViewModel: RadioViewModel
    private let watchSession: OffradioAppWatchSession
    
    private let shortcuts = Shortcuts()
    
    init(window: UIWindow, dependencies: CoreDependencies) {
        self.window = window
        self.dependencies = dependencies
        
        self.offradio = dependencies.offradio
        self.watchCommunication = dependencies.watchCommunication
        self.radioViewModel = RadioViewModel(with: offradio, and: watchCommunication, interfaceFeedback: dependencies.interfaceFeedback)
        self.watchSession = OffradioAppWatchSession(with: offradio,
                                                    networkService: dependencies.networkService,
                                                    andViewModel: self.radioViewModel)
    }
    
    func start() {
        let content = OffradioContentViewController(with: self.dependencies, andViewModel: self.radioViewModel)
        window.rootViewController = content

        window.makeKeyAndVisible()
        self.activateWatchSession()
    }
    
    func handleShortcut(for item: UIApplicationShortcutItem) -> Bool {
        guard let viewController = window.rootViewController as? OffradioContentViewController else {
            return false
        }
        return shortcuts.handle(shortcut: item, for: viewController)
    }
    
    private func activateWatchSession() {
        watchSession.activate()
    }
    
}
