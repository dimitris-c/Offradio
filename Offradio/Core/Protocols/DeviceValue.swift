//
//  DeviceValue.swift
//  Offradio
//
//  Created by Dimitris C. on 25/07/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

protocol DeviceValue { }

extension DeviceValue {
    static func deviceValue(iPhone: Self, iPad: Self) -> Self {
        return UIDevice.current.userInterfaceIdiom == .pad ? iPad : iPhone
    }
}

extension Bool: DeviceValue { }

extension CGFloat: DeviceValue { }
extension Float: DeviceValue { }
extension Int: DeviceValue { }

extension String: DeviceValue { }

extension UIEdgeInsets: DeviceValue { }
extension CGPoint: DeviceValue { }
extension CGSize: DeviceValue { }
