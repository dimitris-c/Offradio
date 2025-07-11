//
//  AppDelegate.swift
//  Offradio
//
//  Created by Dimitris C. on 23/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireNetworkActivityIndicator
import Firebase
import FirebaseCrashlytics
import Network

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var dependencies: CoreDependencies?
    
    var offradioViewModel: RadioViewModel!
    var watchSession: OffradioAppWatchSession?
    let shortcuts: Shortcuts = Shortcuts()
    
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let cache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        URLCache.shared = cache

        FirebaseApp.configure()
        Crashlytics.crashlytics()
        RealmMigrationLayer.performMigration()
        NetworkActivityIndicatorManager.shared.isEnabled = true

        let dependencies = CoreDependenciesService()
        
        let window = UIWindow(frame: UIScreen.main.bounds)

        let appCoordinator = AppCoordinator(window: window, dependencies: dependencies)
        self.window = window
        appCoordinator.start()
        
        self.appCoordinator = appCoordinator
        self.dependencies = dependencies
        
        Theme.applyNavBarAppearance()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Log.debug("application will terminate")
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .allButUpsideDown
        }
        return .portrait
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let coordinator = self.appCoordinator else {
            completionHandler(false)
            return
        }

        let handledShortCutItem = coordinator.handleShortcut(for: shortcutItem)
        completionHandler(handledShortCutItem)
    }

}
