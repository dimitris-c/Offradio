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
    
    var changeSet: Variable<RealmChangeset?> = Variable<RealmChangeset?>(nil)
    
    init(viewWillAppear: Driver<Void>) {
        
        Observable.changeset(from: favouritesDataLayer.allFavourites())
            .subscribe(onNext: { [weak self] results, changes in
                self?.playlistData.value = results.map { PlaylistCellViewModel(with: $0) }
                if let changes = changes {
                    self?.changeSet.value = changes
                }
            }, onCompleted: { _ in
                self.changeSet.value = nil
            })
            .addDisposableTo(disposeBag)
        
    }
}
