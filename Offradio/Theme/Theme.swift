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
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.letterGothicBold(withSize: 16),
                                                            NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white

        UINavigationBar.appearance().barTintColor = UIColor.black
    }
}
