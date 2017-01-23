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

extension UIFont {

    class func defaultLight(withSize size:CGFloat) -> UIFont {
        return font(HelveticaNeue.light.rawValue, size: size)
    }
    
    class func defaultMedium(withSize size:CGFloat) -> UIFont {
        return font(HelveticaNeue.medium.rawValue, size: size)
    }
    
    class func defaultBold(withSize size:CGFloat) -> UIFont {
        return font(HelveticaNeue.bold.rawValue, size: size)
    }
    
    class func defaultRegular(withSize size:CGFloat) -> UIFont {
        return font(HelveticaNeue.regular.rawValue, size: size)
    }
    
    class func font(_ name:String, size:CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
