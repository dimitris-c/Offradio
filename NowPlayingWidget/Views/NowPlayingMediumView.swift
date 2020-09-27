//
//  NowPlayingMediumView.swift
//  OffradioWatchKit Extension
//
//  Created by Dimitrios Chatzieleftheriou on 22/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import WidgetKit
import SwiftUI

struct NowPlayingMediumView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("onair-icon")
                Spacer()
                Image("offradio-logo")
                    .offset(x: 0, y: -3)
            }
            Spacer()
            HStack(alignment: .top, spacing: 16) {
                NetworkImage(urlString: entry.track.artistImage,
                             placeholderName: "artwork-image-placeholder")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(4.0)
                    .foregroundColor(.gray)
                VStack(alignment: .leading){
                    Text("#NOWPLAYING")
                        .font(Font.letterGothic(size: 12))
                        .foregroundColor(.gray)
                    Text(entry.track.artist)
                        .lineLimit(1)
                        .font(Font.leagueGothic(style: .italic, size: 25))
                        .foregroundColor(.white)
                    Text(entry.track.name)
                        .font(Font.system(size: 16))
                        .kerning(-0.4)
                        .lineLimit(2)
                        .font(Font.body)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.NowPlayingWidget.lightBackground)
    }
}

struct NowPlayingMedium_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingWidgetEntryView(entry: NowPlayingEntry(date: Date(), track: .default, playlist: .default))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
