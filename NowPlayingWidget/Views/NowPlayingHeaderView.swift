//
//  NowPlayingHeaderView.swift
//  OffradioWatchKit Extension
//
//  Created by Dimitrios Chatzieleftheriou on 22/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import SwiftUI

struct NowPlayingHeaderView: View {
    var body: some View {
        HStack {
            Image("onair-icon")
            Spacer()
            Image("offradio-logo")
                .offset(x: 0, y: -3)
        }
    }
}

struct NowPlayingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingHeaderView()
    }
}
