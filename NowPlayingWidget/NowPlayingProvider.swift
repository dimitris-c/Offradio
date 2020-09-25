//
//  NowPlayingProvider.swift
//  OffradioWatchKit Extension
//
//  Created by Dimitrios Chatzieleftheriou on 22/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Combine
import WidgetKit

extension Song: Identifiable {
    var id: String {
        return self.title
    }
    
    
}

struct Playlist {
    static let maxSongs = 5
    let songs: [Song]
    
    static let `default`: Playlist = Playlist(songs: [])

}

class Provider: TimelineProvider {
    
    private var cancellables: Set<AnyCancellable> = Set()
    private let apiClient: OffradioAPIClient
    init(apiClient: OffradioAPIClient) {
        self.apiClient = apiClient
    }
    
    func placeholder(in context: Context) -> NowPlayingEntry {
        NowPlayingEntry(date: Date(), track: .default, playlist: .default)
    }

    func getSnapshot(in context: Context, completion: @escaping (NowPlayingEntry) -> ()) {
        if context.isPreview {
            let entry = NowPlayingEntry(date: Date(), track: .default, playlist: .default)
            completion(entry)
        } else {
            self.getWidgetInformation()
                .sink { entry in
                    completion(entry)
                }
                .store(in: &cancellables)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NowPlayingEntry>) -> Void) {
        guard cancellables.isEmpty else {
            cancellables.removeAll()
            return
        }
        self.getWidgetInformation()
            .sink { entry in
                let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
                let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
                completion(timeline)
            }
            .store(in: &cancellables)
    }
    
    private func getWidgetInformation() -> AnyPublisher<NowPlayingEntry, Never> {
        self.apiClient.getNowPlaying()
            .zip(self.apiClient.getPlaylist())
            .map { (track, songs) -> NowPlayingEntry in
                let redactedSongs = Array(songs[..<Playlist.maxSongs])
                return NowPlayingEntry(date: Date(), track: track, playlist: Playlist(songs: redactedSongs))
            }
            .replaceError(with: NowPlayingEntry(date: Date(), track: .default, playlist: .default))
            .eraseToAnyPublisher()
    }
}

struct NowPlayingEntry: TimelineEntry {
    let date: Date
    let track: CurrentTrack
    let playlist: Playlist
}
