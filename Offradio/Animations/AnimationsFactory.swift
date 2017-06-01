//
//  AnimationsFactory.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

final class AnimationsFactory {
    
    class func fadeIn(withDuration duration: CFTimeInterval) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.duration = duration
        animation.fromValue = 0.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return animation
    }
    
    class func fadeOut(withDuration duration: CFTimeInterval) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.duration = duration
        animation.fromValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return animation
    }
    
    class func rotate(withDuration duration: CFTimeInterval, indefinetely nonStop: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.duration = duration
        animation.repeatCount = nonStop ? Float.greatestFiniteMagnitude : 0
        animation.autoreverses = false
        animation.isCumulative = true
        animation.isAdditive = true
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        animation.fromValue = NSNumber(floatLiteral: 0)
        animation.toValue = NSNumber(floatLiteral: Double.pi * 2.0)
        
        return animation
    }
    
}
