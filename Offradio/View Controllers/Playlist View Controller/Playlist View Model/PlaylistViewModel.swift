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
import RealmSwift
import RxRealm

final class PlaylistViewModel {
    
    private let disposeBag = DisposeBag()
    
    private var service: PlaylistService!
    
    let initialLoad: Variable<Bool> = Variable<Bool>(true)
    
    let refresh: Variable<Bool> = Variable<Bool>(false)
    
    let indicatorViewAnimating: Variable<Bool> = Variable<Bool>(false)
    
    var playlistData: Variable<[PlaylistCellViewModel]> = Variable<[PlaylistCellViewModel]>([])
    
    fileprivate var page: Int = 0
    fileprivate let totalPagesToFetch: Int = 10
    
    init(viewWillAppear: Driver<Void>, scrollViewDidReachBottom: Driver<Void>) {
        
        self.refresh.asObservable().subscribe(onNext: { [weak self] refresh in
            guard let strongSelf = self else { return }
            if refresh && !strongSelf.indicatorViewAnimating.value {
                strongSelf.page = 0
                strongSelf.fetchPlaylist(withPage: 0)
            }
        }).addDisposableTo(disposeBag)

        viewWillAppear.asObservable()
            .map { _ in 0 }
            .subscribe(onNext: { [weak self] page in
                self?.fetchPlaylist(withPage: page)
            })
            .addDisposableTo(disposeBag)
    
        scrollViewDidReachBottom.asObservable().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self, !strongSelf.indicatorViewAnimating.value else { return }
            if strongSelf.page <= strongSelf.totalPagesToFetch {
                strongSelf.fetchPlaylist(withPage: strongSelf.page)
                strongSelf.indicatorViewAnimating.value = true
            }
        }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: Internal methods
    
    fileprivate func fetchPlaylist(withPage page: Int) {
        self.service = PlaylistService(withPage: page)
        self.service.call({ [weak self] (success, data, headers) in
            guard let strongSelf = self else { return }
            if let items = data.value {
                if strongSelf.page == 0 {
                    strongSelf.playlistData.value = items.map { PlaylistCellViewModel(with: $0) }
                } else {
                    strongSelf.playlistData.value.append(contentsOf: items.map { PlaylistCellViewModel(with: $0) })
                }
                strongSelf.page = strongSelf.page + 1
            }
            strongSelf.refresh.value = false
            strongSelf.indicatorViewAnimating.value = false
            strongSelf.initialLoad.value = false
        })
    }
    
}
