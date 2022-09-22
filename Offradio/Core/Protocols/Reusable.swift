//
//  Reusable.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

public protocol Reusable: AnyObject {
    static var identifier: String { get }
}

public extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
