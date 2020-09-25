//
//  NowPlayingWidget.swift
//  NowPlayingWidget
//
//  Created by Dimitrios Chatzieleftheriou on 21/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import WidgetKit
import SwiftUI

struct NowPlayingWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
            case .systemSmall:
                NowPlayingSmallView(entry: entry)
            case .systemMedium:
                NowPlayingMediumView(entry: entry)
            case .systemLarge:
                NowPlayingLargeView(entry: entry)
            @unknown default:
                NowPlayingMediumView(entry: entry)
        }
    }
}


struct NowPlayingWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NowPlayingWidgetEntryView(entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            NowPlayingWidgetEntryView(entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            NowPlayingWidgetEntryView(entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default))
                .previewContext(WidgetPreviewContext(family: .systemLarge))

        }
    }
}
