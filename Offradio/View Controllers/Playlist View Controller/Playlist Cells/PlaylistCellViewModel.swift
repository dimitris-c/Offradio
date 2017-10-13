//
//  PlaylistCellViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 15/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Crashlytics

final class PlaylistCellViewModel {

    var disposeBag: DisposeBag?

    private(set) var item: PlaylistSong!

    var favourited: Variable<Bool> = Variable<Bool>(false)
    let playlistFavouritesLayer: PlaylistFavouritesLayer = PlaylistFavouritesLayer()

    init(with item: PlaylistSong) {
        self.item = item
    }

    func initialise(with driver: Driver<Bool>) {
        disposeBag = DisposeBag()

        favourited.value = self.playlistFavouritesLayer.isFavourite(for: self.item.artist, songTitle: self.item.songTitle)

        let tapObservable = driver.asObservable().subscribe(onNext: { [weak self] shouldFavourite in
            guard let strongSelf = self else { return }

            let artist: String = strongSelf.item.artist
            let songTitle: String = strongSelf.item.songTitle

            let itemExists: Bool = strongSelf.playlistFavouritesLayer.isFavourite(for: artist, songTitle: songTitle)
            if shouldFavourite && !itemExists {
                try? strongSelf.playlistFavouritesLayer.createFavourite(with: strongSelf.item)
                self?.trackAddedSong(with: strongSelf.item.toSong())
                strongSelf.favourited.value = true
            } else {
                self?.trackRemovedSong(with: strongSelf.item.toSong())
                try? strongSelf.playlistFavouritesLayer.deleteFavourite(for: artist, songTitle: songTitle)
                strongSelf.favourited.value = false
            }
        })

        disposeBag?.insert(tapObservable)
    }

    private func trackAddedSong(with song: Song) {
        let attributes: [String: Any] = ["song": song.title]
        Answers.logContentView(withName: "Added favourite", contentType: "favourite", contentId: nil, customAttributes: attributes)
    }

    private func trackRemovedSong(with song: Song) {
        let attributes: [String: Any] = ["song": song.title]
        Answers.logContentView(withName: "Removed favourite", contentType: "favourite", contentId: nil, customAttributes: attributes)
    }

}
