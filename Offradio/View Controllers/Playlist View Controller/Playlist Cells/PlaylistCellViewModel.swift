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

final class PlaylistCellViewModel {
    
    let disposeBag = DisposeBag()
    
    private(set) var item: PlaylistSong!
    
    var favouriteItem: Variable<Bool> = Variable<Bool>(false)
    
    init(with item: PlaylistSong) {
        self.item = item
        
        favouriteItem.asObservable().subscribe(onNext: { [weak self] shouldFavourite in
            guard let strongSelf = self else { return }
            Log.debug("should favourite: \(strongSelf.item)")
            let realm = try! Realm()
            try! realm.write {
                let song = PlaylistSong(value: strongSelf.item)
                realm.add(song)
            }
        }).addDisposableTo(disposeBag)
        
//        favouriteItem.asObservable().subscribe(onNext: { item in
//            if let item = item  {
//                Log.debug("should favourite: \(item)")
//                let realm = try! Realm()
//                try! realm.write {
//                    let song = PlaylistSong(value: item)
//                    song.isFavourite = true
//                    realm.add(song)
//                }
//            }
//        }).addDisposableTo(disposeBag)
        
    }
    
    func isFavourite(for artist: String, songTitle title: String) -> Bool {
        let realm = try! Realm()
        let item = realm.objects(PlaylistSong.self).filter("")
    }
    
}
