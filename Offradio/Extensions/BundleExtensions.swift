//
//  BundleExtentsions.swift
//  Offradio
//
//  Created by Dimitris C. on 17/10/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
