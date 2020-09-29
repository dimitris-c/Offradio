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
        Font(UIFont.robotoRegular(withSize: size))
    }
    
    static func roboto(style: RobotoMono, size: CGFloat) -> Font {
        Font(UIFont.font(style.rawValue, size: size))
    }
    
}
