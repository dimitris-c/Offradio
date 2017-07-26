//
//  Constants.swift
//  Offradio
//
//  Created by Dimitris C. on 23/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

struct ScreenSize {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    static let screenMaxLength    = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength    = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone           = UIDevice.current.userInterfaceIdiom == .phone
    static let iPhone4OrLess    = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let iPhone5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let iPhone6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let iPhone6s         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let iPad             = UIDevice.current.userInterfaceIdiom == .pad
}

struct Version {
    static let sysVersionFloat = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.sysVersionFloat < 8.0 && Version.sysVersionFloat >= 7.0)
    static let iOS8 = (Version.sysVersionFloat >= 8.0 && Version.sysVersionFloat < 9.0)
    static let iOS9 = (Version.sysVersionFloat >= 9.0 && Version.sysVersionFloat < 10.0)
}
