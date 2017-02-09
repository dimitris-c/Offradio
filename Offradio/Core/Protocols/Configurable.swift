//
//  Configurable.swift
//  Offradio
//
//  Created by Dimitris C. on 09/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

protocol ConfigurableCell {
    associatedtype Item
    func configure<Item>(with item: Item)
}
