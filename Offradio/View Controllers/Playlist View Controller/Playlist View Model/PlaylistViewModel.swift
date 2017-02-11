//
//  PlaylistViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 11/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Realm

final class PlaylistViewModel {
    
    private let disposeBag = DisposeBag()
    
    fileprivate var playlistService: PlaylistService!
    
    let refresh: Variable<Bool> = Variable<Bool>(false)
    
    var page: Variable<Int> = Variable<Int>(0)
    
    var playlistData: Variable<[PlaylistSong]> = Variable<[PlaylistSong]>([])
    
    init() {
        
        self.playlistService = PlaylistService()
        
        self.fetchPlaylist(withPage: 0).catchErrorJustReturn([]).bindTo(playlistData).addDisposableTo(disposeBag)
        
        
    }

    // MARK: Internal methods
    
    fileprivate func fetchPlaylist(withPage page: Int) -> Observable<[PlaylistSong]> {
        return self.playlistService.with(page: page).rxCall().do(onError: { [weak self] (_) in
                self?.refresh.value = false
            }, onCompleted: { [weak self] in
                self?.refresh.value = false
        })
    }
    
}
