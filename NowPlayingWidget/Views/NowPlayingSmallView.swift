//
//  NowPlayingSmallView.swift
//  OffradioWatchKit Extension
//
//  Created by Dimitrios Chatzieleftheriou on 22/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import WidgetKit
import SwiftUI

struct NowPlayingSmallView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            NowPlayingHeaderView()
            Spacer()
            CurrentTrackView(entry: entry)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.NowPlayingWidget.lightBackground)
    }
}


struct NowPlayingSmall_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingWidgetEntryView(entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
