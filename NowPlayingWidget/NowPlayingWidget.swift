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

    var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular, .accessoryInline]
        } else {
            return [.systemSmall, .systemMedium, .systemLarge]
        }
    }

    var body: some WidgetConfiguration {
        let provider = Provider(apiClient: OffradioAPIClient(networkClient: networkClient))
        return StaticConfiguration(kind: kind, provider: provider) { entry in
            NowPlayingWidgetEntryView(entry: entry)
        }
        .supportedFamilies(supportedFamilies)
        .configurationDisplayName("Now Playing")
        .description("Quickly see what's playing on OFFRadio")
    }
}
