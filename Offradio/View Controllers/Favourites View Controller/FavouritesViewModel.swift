//
//  FavouritesViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 21/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class FavouritesViewModel {
    private let disposeBag = DisposeBag()

    let favouritesDataLayer: PlaylistFavouritesLayer = PlaylistFavouritesLayer()
    var playlistData: Variable<[PlaylistCellViewModel]> = Variable<[PlaylistCellViewModel]>([])

    init(viewWillAppear: Driver<Void>) {

        Observable.array(from: favouritesDataLayer.allFavourites())
            .map { $0.map { PlaylistCellViewModel(with: $0) } }
            .bind(to: playlistData)
            .addDisposableTo(disposeBag)

    }
}
