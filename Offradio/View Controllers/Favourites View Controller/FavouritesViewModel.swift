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
        
//        playlistData.value = favouritesDataLayer.allFavourites().map { PlaylistCellViewModel(with: $0) }
                
        Observable.changeset(from: favouritesDataLayer.allFavourites())
            .subscribe(onNext: { results, changes in
            if let changes = changes {

            } else {
                
            }
        }).addDisposableTo(disposeBag)
        
    }
}
