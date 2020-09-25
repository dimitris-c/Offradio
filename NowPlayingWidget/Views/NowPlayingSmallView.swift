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
            VStack(alignment: .leading){
                Text("#NOWPLAYING")
                    .font(Font.letterGothic(size: 11))
                    .foregroundColor(.gray)
                Text(entry.track.artist)
                    .lineLimit(2)
                    .font(Font.leagueGothic(style: .italic, size: 22))
                    .foregroundColor(.white)
                Text(entry.track.name)
                    .font(Font.system(size: 15))
                    .kerning(-0.4)
                    .lineLimit(3)
                    .font(Font.body)
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Gradient.NowPlayingWidget.background)
    }
}


struct NowPlayingSmall_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingWidgetEntryView(entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
