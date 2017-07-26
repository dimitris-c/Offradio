//
//  UIApplicationExtensions.swift
//  Offradio
//
//  Created by Dimitris C. on 10/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

extension UIApplication {

    @discardableResult
    class func open(url aUrl: URL) -> Bool {
        if UIApplication.shared.canOpenURL(aUrl) {
            return UIApplication.shared.openURL(aUrl)
        }
        return false
    }

}
