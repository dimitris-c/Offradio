//
//  UIViewExtensions.swift
//  Offradio
//
//  Created by Dimitris C. on 21/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

struct ShadowAttributes {
    var color: UIColor = UIColor.black
    var offset: CGSize = CGSize(width: 0, height: 0)
    var radius: CGFloat = 0.0
    var opacity: Float = 0.0

    static let zero = ShadowAttributes(color: UIColor.clear, offset: CGSize.zero, radius: 0, opacity: 0)
}

extension UIView {

    func applyShadow(with attributes: ShadowAttributes) {
        self.layer.applyShadow(with: attributes)
    }

}

extension CALayer {
    final func applyShadow(with attributes: ShadowAttributes, path: CGPath? = nil) {
        self.shadowColor = attributes.color.cgColor
        self.shadowOffset = attributes.offset
        self.shadowRadius = attributes.radius
        self.shadowOpacity = attributes.opacity
        self.shadowPath = path
    }
}
