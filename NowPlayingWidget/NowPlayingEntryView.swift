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
        if #available(iOSApplicationExtension 16.0, *) {
            switch family {
            case .systemSmall:
                NowPlayingSmallView(entry: entry)
            case .systemMedium:
                NowPlayingMediumView(entry: entry)
            case .systemLarge:
                NowPlayingLargeView(entry: entry)
            case .systemExtraLarge:
                NowPlayingLargeView(entry: entry)
            case .accessoryCircular:
                EmptyView()
            case .accessoryRectangular:
                ViewThatFits {
                    HStack(alignment: .top) {
                        Image("offradio-logo")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .center)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(entry.track.artist)
                                .font(.headline)
                            Text(entry.track.name)
                                .font(.caption)
                                .lineLimit(2)
                        }
                    }
                }
            case .accessoryInline:
                EmptyView()
            @unknown default:
                NowPlayingMediumView(entry: entry)
            }
        } else {
            switch family {
            case .systemSmall:
                NowPlayingSmallView(entry: entry)
            case .systemMedium:
                NowPlayingMediumView(entry: entry)
            case .systemLarge:
                NowPlayingLargeView(entry: entry)
            case .systemExtraLarge:
                NowPlayingLargeView(entry: entry)
            @unknown default:
                NowPlayingMediumView(entry: entry)
            }
        }
    }
}


struct NowPlayingWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NowPlayingWidgetEntryView(
                entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default)
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            NowPlayingWidgetEntryView(
                entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default)
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))

            NowPlayingWidgetEntryView(
                entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default)
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))

            if #available(iOSApplicationExtension 16.0, *) {
                NowPlayingWidgetEntryView(
                    entry: NowPlayingEntry(date: Date(), track: .preview, playlist: .default)
                )
                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))

                NowPlayingWidgetEntryView(
                    entry: NowPlayingEntry(date: Date(), track: .preview, playlist: .default)
                )
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewDisplayName("Acccessory Rectangular")
            }
        }
    }
}
