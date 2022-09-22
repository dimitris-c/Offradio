//
//  Theme.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

struct Theme {

    static func setupNavBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.robotoRegular(withSize: 16),
                                          NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor.black

        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.buttonAppearance = barButtonItemAppearance
        appearance.backButtonAppearance = barButtonItemAppearance
        appearance.doneButtonAppearance = barButtonItemAppearance

        return appearance
    }

    static func setupTabBarAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        return appearance
    }

    static func applyNavBarAppearance() {
        let newNavBarAppearance = setupNavBarAppearance()

        let appearance = UINavigationBar.appearance()
        appearance.tintColor = .white
        appearance.scrollEdgeAppearance = newNavBarAppearance
        appearance.compactAppearance = newNavBarAppearance
        appearance.standardAppearance = newNavBarAppearance
        if #available(iOS 15.0, *) {
            appearance.compactScrollEdgeAppearance = newNavBarAppearance
        }

        let newTabBarAppearance = setupTabBarAppearance()
        let tabBarAppearance = UITabBar.appearance()
        if #available(iOS 15.0, *) {
            tabBarAppearance.scrollEdgeAppearance = newTabBarAppearance
        }
        tabBarAppearance.standardAppearance = newTabBarAppearance
    }
}
