//
//  NowPlayingWidgetMain.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 22/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct NowPlayingWidget: Widget {
    let kind: String = "NowPlayingWidget"
    
    private let networkClient = NetworkClient(session: .shared)

    var body: some WidgetConfiguration {
        let provider = Provider(apiClient: OffradioAPIClient(networkClient: networkClient))
        return StaticConfiguration(kind: kind, provider: provider) { entry in
            NowPlayingWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Now Playing")
        .description("Quickly see what's playing on OFFRadio")
    }
}
