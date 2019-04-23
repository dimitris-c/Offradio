//
//  AppDelegate.swift
//  Offradio
//
//  Created by Dimitris C. on 23/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import Crashlytics
import FBSDKCoreKit
import RealmSwift
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var offradio: Offradio!
    var offradioViewModel: RadioViewModel!
    var watchSession: OffradioAppWatchSession?
    let shortcuts: Shortcuts = Shortcuts()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let cache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        URLCache.shared = cache

        Fabric.with([Crashlytics.self, Answers.self])
        TWTRTwitter.sharedInstance().start(withConsumerKey: "AfJ2HbxzaW4gvPekIwHdak4RS",
                                       consumerSecret: "KRgr4T0Yk4AeVlwDIWvUra00tjRkjhCCWUpGV3dPeoTpDKqymt")

        RealmMigrationLayer.performMigration()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        NetworkActivityIndicatorManager.shared.isEnabled = true

        window = UIWindow(frame: UIScreen.main.bounds)

        self.offradio = Offradio()
        let watchCommunication = OffradioWatchCommunication()
        self.offradioViewModel = RadioViewModel(with: self.offradio, and: watchCommunication)

        let content = OffradioContentViewController(with: self.offradio, andViewModel: self.offradioViewModel)
        window?.rootViewController = content

        window?.makeKeyAndVisible()

        Theme.setupNavBarAppearance()

        watchSession = OffradioAppWatchSession(with: self.offradio, andViewModel: self.offradioViewModel)
        watchSession?.activate()

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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Log.debug("application will terminate")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                            open: url,
                                                                            sourceApplication: sourceApplication,
                                                                            annotation: annotation)
        return handled
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let viewController = window?.rootViewController as? OffradioContentViewController else {
            completionHandler(false)
            return
        }

        let handledShortCutItem = self.shortcuts.handle(shortcut: shortcutItem, for: viewController)
        completionHandler(handledShortCutItem)
    }

}
