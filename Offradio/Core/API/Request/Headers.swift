//
//  Headers.swift
//  Carlito
//
//  Created by Dimitris C. on 17/09/2016.
//  Copyright © 2016 decimal. All rights reserved.
//

import Foundation

final class Headers {
    final let values: [String: String]?
    
    init(headers someHeaders: [String: String]?) {
        self.values = someHeaders
    }
    
}
