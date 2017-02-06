//
//  Utils.swift
//  Carlito
//
//  Created by Dimitris C. on 24/07/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    convenience init?(hex:String, alpha:Float = 1.0) {
        var hexString:String = hex
        if hex.hasPrefix("#") {
            hexString = String(hex.characters.dropFirst())
        }
        var hexValue: UInt32 = 0
        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            return nil
        }
        let divisor = CGFloat(255)
        let red     = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hexValue & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hexValue & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
