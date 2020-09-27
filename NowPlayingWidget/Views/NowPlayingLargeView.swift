//
//  NowPlayingSmallView.swift
//  OffradioWatchKit Extension
//
//  Created by Dimitrios Chatzieleftheriou on 22/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import WidgetKit
import SwiftUI

struct NowPlayingLargeView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image("onair-icon")
                    Spacer()
                    Image("offradio-logo")
                        .offset(x: 0, y: -3)
                }
                .padding(.bottom, 16)
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
            .padding(.all, 16)
            .background(Color.NowPlayingWidget.background)
            VStack(alignment: .leading) {
                Text("OFFRADIO PLAYLIST")
                    .font(Font.leagueGothic(style: .italic, size: 20))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                    .padding(.leading, 16)
                    .padding(.bottom, 4)
                ForEach(entry.playlist.songs) { song in
                    PlaylistRow(song: song)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.NowPlayingWidget.lightBackground)
    }
}

struct PlaylistRow: View {
    let song: Song
    
    var body: some View {
        HStack(alignment: .top, spacing: 3) {
            Text(song.time + ":")
                .foregroundColor(Color.NowPlayingWidget.lightGray)
                .font(Font.system(size: 13, weight: .semibold, design: .rounded))
            Text(song.titleFormatted)
                .lineLimit(2)
                .font(Font.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(.trailing, 16)
                .padding(.bottom, 4)
        }
        .padding(.leading, 16)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct NowPlayingLarge_Previews: PreviewProvider {
    static var previews: some View {
        let playlist = Playlist(
            songs: [
                Song(with: Date(), artist: "Duke Dumont", songTitle: "Let me go (Cerrone Remix)", trackImage: ""),
                Song(with: Date(), artist: "Moby", songTitle: "Victoria Lucas", trackImage: ""),
                Song(with: Date(), artist: "Louis la Roche", songTitle: "Back to you (luxar brosas remo)", trackImage: ""),
                Song(with: Date(), artist: "The Beloved", songTitle: "Sun Rising (Dee montenergo remix)", trackImage: ""),
                Song(with: Date(), artist: "Chromatics", songTitle: "Cherry", trackImage: ""),
            ])
        NowPlayingWidgetEntryView(entry: NowPlayingEntry(date: Date(), track: .default, playlist: playlist))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
