//
//  CurrentTrackView.swift
//  NowPlayingWidgetExtension
//
//  Created by Dimitrios Chatzieleftheriou on 27/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import SwiftUI

struct CurrentTrackView: View {
    var entry: Provider.Entry
    var showsArtwork: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if showsArtwork {
                NetworkImage(urlString: entry.track.artistImage,
                             placeholderName: "artwork-image-placeholder")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(4.0)
                    .foregroundColor(.gray)
            }
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
}

struct CurrentTrackView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTrackView(entry: Provider.Entry(date: Date(), track: .default, playlist: .default))
    }
}
