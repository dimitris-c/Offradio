//
//  Utils.swift
//  Carlito
//
//  Created by Dimitris C. on 10/08/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import UIKit

public enum HelveticaNeue: String {
    case light      = "HelveticaNeue-Light"
    case regular    = "HelveticaNeue-Regular"
    case medium     = "HelveticaNeue-Medium"
    case bold       = "HelveticaNeue-Bold"
}

public enum RobotoMono: String {
    case regular                = "RobotoMono-Regular"
    case condesedBoldItalic    = "RobotoCondensed-BoldItalic"
}

public enum LeagueGothic: String {
    case italic     = "LeagueGothic-Italic"
    case regular    = "LeagueGothic-Regular"
}

extension UIFont {

    class func leagueGothicRegular(withSize size: CGFloat) -> UIFont {
        return font(LeagueGothic.regular.rawValue, fallback: RobotoMono.condesedBoldItalic.rawValue, size: size)
    }

    class func leagueGothicItalic(withSize size: CGFloat) -> UIFont {
        return font(LeagueGothic.italic.rawValue, fallback: RobotoMono.condesedBoldItalic.rawValue, size: size)
    }

    class func robotoRegular(withSize size: CGFloat) -> UIFont {
        return font(RobotoMono.regular.rawValue, size: size)
    }

    class func defaultLight(withSize size: CGFloat) -> UIFont {
        return font(HelveticaNeue.light.rawValue, size: size)
    }

    class func defaultMedium(withSize size: CGFloat) -> UIFont {
        return font(HelveticaNeue.medium.rawValue, size: size)
    }

    class func defaultBold(withSize size: CGFloat) -> UIFont {
        return font(HelveticaNeue.bold.rawValue, size: size)
    }

    class func defaultRegular(withSize size: CGFloat) -> UIFont {
        return font(HelveticaNeue.regular.rawValue, size: size)
    }

    class func font(_ name: String, fallback: String? = nil, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else { return .systemFont(ofSize: size)}
        let descriptor = font.fontDescriptor
        
        if let fallback = fallback {
            let fallbackDescriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.name: fallback])
            let descriptorWithFallback = descriptor.addingAttributes(
                [
                    UIFontDescriptor.AttributeName.cascadeList : [fallbackDescriptor]
                ]
            )
            return UIFont(descriptor: descriptorWithFallback, size: size)
        }
        
        return UIFont(descriptor: descriptor, size: size)
    }
}
