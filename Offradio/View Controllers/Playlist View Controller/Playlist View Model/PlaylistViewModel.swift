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
import Action

final class PlaylistViewModel {
    
    private let disposeBag = DisposeBag()
    
//    fileprivate var playlistService: PlaylistService!
    
    let refresh: Variable<Bool> = Variable<Bool>(false)
    
    let playlistData: Variable<[PlaylistSong]> = Variable<[PlaylistSong]>([])
    
    fileprivate var totalPagesToFetch: Int = 10
    fileprivate var isLoadingNext: Bool = false
    
    init(viewWillAppear: Driver<Void>, scrollViewDidReachBottom: Driver<Void>) {
        
//        self.playlistService = PlaylistService()
    
        
//        self.fetchPlaylist(withPage: 0).catchErrorJustReturn([]).bindTo(playlistData).addDisposableTo(disposeBag)
        
//        self.refresh.asObservable().filter { $0 }.flatMapLatest { _ -> Observable<[PlaylistSong]> in
//            return self.fetchPlaylist(withPage: 0)
//        }.bindTo(playlistData).addDisposableTo(disposeBag)
        
        
        
    }

    // MARK: Internal methods
    
//    fileprivate func fetchPlaylist(withPage page: Int) -> Observable<[PlaylistSong]> {
//        return self.playlistService.with(page: page).rxCall().do(onError: { [weak self] (_) in
//                self?.refresh.value = false
//                self?.isLoadingNext = false
//            }, onCompleted: { [weak self] in
//                self?.refresh.value = false
//                self?.isLoadingNext = false
//        })
//    }
    
}
