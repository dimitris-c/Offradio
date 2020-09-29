//
//  FontStyles.swift
//  OffradioWatchKit Extension
//
//  Created by Dimitrios Chatzieleftheriou on 22/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import SwiftUI

extension Font {
    static func robotoRegular(size: CGFloat) -> Font {
        Font.custom(RobotoMono.regular.rawValue, size: size)
    }
    
    static func leagueGothic(style: LeagueGothic, size: CGFloat) -> Font {
        Font.custom(style.rawValue, size: size)
    }
    
}
