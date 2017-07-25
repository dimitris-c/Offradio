//
//  Constants.swift
//  Offradio
//
//  Created by Dimitris C. on 23/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

struct ScreenSize {
    static var SCREEN_WIDTH:CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var SCREEN_HEIGHT:CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad
}

struct Version
{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}

//MARK: Extensions for platforms

extension UIEdgeInsets {
    static func deviceValue<T>(iPhone:T, iPad:T) -> T {
        if DeviceType.IS_IPAD {
            return iPad
        } else {
            return iPhone
        }
    }
}

extension FloatingPoint {
    static func deviceValue<T>(iPhone:T, iPad:T) -> T {
        if DeviceType.IS_IPAD {
            return iPad
        } else {
            return iPhone
        }
    }
}

extension CGSize {
    static func deviceValue<T>(iPhone:T, iPad:T) -> T {
        if DeviceType.IS_IPAD {
            return iPad
        } else {
            return iPhone
        }
    }
}

extension Bool {
    static func deviceValue<T>(iPhone:T, iPad:T) -> T {
        if DeviceType.IS_IPAD {
            return iPad
        } else {
            return iPhone
        }
    }
}

extension String {
    static func deviceValue<T>(iPhone:T, iPad:T) -> T {
        if DeviceType.IS_IPAD {
            return iPad
        } else {
            return iPhone
        }
    }
}
