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

final class NowPlayingViewModel {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var radioMetadata: OffradioMetadata!
    fileprivate var favouritesLayer: PlaylistFavouritesLayer!
    
    var nowPlaying: Variable<NowPlaying>? {
        if let metadata = self.radioMetadata {
            return metadata.nowPlaying
        }
        return nil
    }
    
    let favouriteTrack: Variable<Bool>       = Variable<Bool>(false)
    let currentTrack: Variable<CurrentTrack> = Variable<CurrentTrack>(CurrentTrack.empty)
    let show: Variable<Show>                 = Variable<Show>(Show.default)
    
    init(with radioMetadata: OffradioMetadata) {
        self.radioMetadata = radioMetadata
        
        self.favouritesLayer = PlaylistFavouritesLayer()
        
        self.radioMetadata.nowPlaying.asObservable()
            .map { $0.show }
            .startWith(Show.default)
            .bind(to: show)
            .addDisposableTo(disposeBag)
        
        self.radioMetadata.nowPlaying.asObservable()
            .map { $0.current }
            .startWith(CurrentTrack.default)
            .do(onNext: { [weak self] track in
                if track != CurrentTrack.default {
                    self?.favouriteTrack.value = self?.favouritesLayer.isFavourite(for: track.artist, songTitle: track.track) ?? false
                }
            })
            .bind(to: currentTrack)
            .addDisposableTo(disposeBag)
        
        self.favouriteTrack.asObservable()
            .subscribe(onNext: { [weak self] (favourite) in
                let track = self?.currentTrack.value
                if let track = track {
                    if favourite && !(self?.favouritesLayer.isFavourite(for: track.artist, songTitle: track.track) ?? false) {
                        let model = track.toPlaylistSong()
                        try? self?.favouritesLayer.createFavourite(with: model)
                    }
                    else if !favourite {
                        try? self?.favouritesLayer.deleteFavourite(for: track.artist, songTitle: track.track)
                    }
                }
                
            }).addDisposableTo(disposeBag)
        
    }
    
    func checkForUpdatesInFavourite() {
        let track = self.currentTrack.value
        if track != CurrentTrack.default {
            self.favouriteTrack.value = self.favouritesLayer.isFavourite(for: track.artist, songTitle: track.track)
        }
    }
    
}
