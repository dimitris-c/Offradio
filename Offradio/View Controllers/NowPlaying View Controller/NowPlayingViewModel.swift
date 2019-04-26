//
//  NowPlayingViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import Crashlytics

final class NowPlayingViewModel {
    fileprivate let radioMetadata: RadioMetadata
    fileprivate let favouritesLayer: PlaylistFavouritesLayer

    var nowPlaying: BehaviorRelay<NowPlaying> {
        return self.radioMetadata.nowPlaying
    }
    
    let viewWillAppear = PublishRelay<Void>()
    let markTrackAsFavourite = PublishSubject<Bool>()

    let favouriteTrack: Driver<Bool>
    let currentTrack: Driver<CurrentTrack>
    let show: Driver<Show>

    init(with radioMetadata: RadioMetadata) {
        self.radioMetadata = radioMetadata

        self.favouritesLayer = PlaylistFavouritesLayer()

        let nowPlaying  = self.radioMetadata.nowPlaying
            .share(replay: 1, scope: .whileConnected)
        
        self.show = nowPlaying
            .map { $0.show }
            .startWith(Show.default)
            .asDriver(onErrorJustReturn: .default)

        self.currentTrack = nowPlaying
            .map { $0.current }
            .startWith(CurrentTrack.default)
            .asDriver(onErrorJustReturn: .default)
        
        let checkIfFavourite = self.viewWillAppear
            .withLatestFrom(self.currentTrack.asObservable())
            .flatMapLatest { [favouritesLayer] track -> Observable<Bool> in
                if track != CurrentTrack.default {
                    let isFavourite = favouritesLayer.isFavourite(for: track.artist, songTitle: track.track)
                    return .just(isFavourite)
                }
                return .just(false)
            }
        
        let markAsFavourite = markTrackAsFavourite.asObservable()
            .withLatestFrom(self.currentTrack.asObservable()) { ($0, $1) }
            .flatMapLatest { [favouritesLayer] (shouldFavourite, track) -> Observable<Bool> in
                if shouldFavourite && !favouritesLayer.isFavourite(for: track.artist, songTitle: track.track) {
                    let model = track.toPlaylistSong()
                    try? favouritesLayer.createFavourite(with: model)
                    NowPlayingViewModel.trackAddedSong(with: track.toSong())
                    return .just(true)
                } else if !shouldFavourite {
                    try? favouritesLayer.deleteFavourite(for: track.artist, songTitle: track.track)
                    NowPlayingViewModel.trackRemovedSong(with: track.toSong())
                    return .just(false)
                }
                return .just(false)
            }
        
        self.favouriteTrack = Observable.merge(checkIfFavourite, markAsFavourite)
            .asDriver(onErrorJustReturn: false)

    }

    private static func trackAddedSong(with song: Song) {
        let attributes: [String: Any] = ["song": song.title]
        Answers.logContentView(withName: "Added favourite", contentType: "favourite", contentId: nil, customAttributes: attributes)
    }

    private static func trackRemovedSong(with song: Song) {
        let attributes: [String: Any] = ["song": song.title]
        Answers.logContentView(withName: "Removed favourite", contentType: "favourite", contentId: nil, customAttributes: attributes)
    }

}
