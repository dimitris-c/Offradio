//
//  Theme.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

struct Theme {

    static func setupNavBarAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.robotoRegular(withSize: 16),
                                                            NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white

        UINavigationBar.appearance().barTintColor = UIColor.black

    }
}
