//
//  ShortcutsEnum.swift
//  Offradio
//
//  Created by Dimitris C. on 25/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//
import Foundation

enum ShortcutIdentifier: String {
    case radio
    case schedule
    case playlist
    case favourites

    init?(fullType: String) {

        guard let last = fullType.components(separatedBy: ".").last else { return nil }
        self.init(rawValue: last)
    }

    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
}
