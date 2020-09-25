//
//  GradientStyles.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 23/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import SwiftUI

extension Gradient {
    struct NowPlayingWidget {
        static let defaultGradient = Gradient(colors: [Color.NowPlayingWidget.darkGray, Color.black])
        static let background = LinearGradient(gradient: defaultGradient, startPoint: .top, endPoint: .center)
    }
}
