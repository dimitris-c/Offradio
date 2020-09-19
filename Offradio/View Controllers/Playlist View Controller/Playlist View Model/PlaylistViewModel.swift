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
import Moya

public enum PlaylistCellSearchProvider: String {
    case itunes
    case spotify
}

public enum SearchResultError: Error {
    case noResult
}
public typealias SearchBlock = (Result<String, SearchResultError>) -> Void

final class PlaylistViewModel {

    private let disposeBag = DisposeBag()

    let initialLoad = BehaviorRelay<Bool>(value: true)

    let refresh = BehaviorRelay<Bool>(value: false)

    let indicatorViewAnimating = BehaviorRelay<Bool>(value: false)

    var playlistData = BehaviorRelay<[PlaylistCellViewModel]>(value: [])

    let playlistService = MoyaProvider<PlaylistService>()

    fileprivate var page: Int = 1
    fileprivate let totalPagesToFetch: Int = 10

    init(viewWillAppear: Driver<Void>, scrollViewDidReachBottom: Driver<Void>) {

        self.refresh.asObservable().subscribe(onNext: { [weak self] refresh in
            guard let strongSelf = self else { return }
            if refresh && !strongSelf.indicatorViewAnimating.value {
                strongSelf.page = 1
                
                strongSelf.fetchPlaylist(withPage: 1)
            }
        }).disposed(by: disposeBag)

        viewWillAppear.asObservable()
            .take(1)
            .map { _ in 1 }
            .subscribe(onNext: { [weak self] page in
                guard let sSelf = self else { return }
                sSelf.fetchPlaylist(withPage: page)
            })
            .disposed(by: disposeBag)

        scrollViewDidReachBottom.asObservable().subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self, !strongSelf.indicatorViewAnimating.value else { return }
            if strongSelf.page <= strongSelf.totalPagesToFetch {
                strongSelf.fetchPlaylist(withPage: strongSelf.page)
                strongSelf.indicatorViewAnimating.accept(true)
            }
        }).disposed(by: disposeBag)

    }

    func search(on provider: PlaylistCellSearchProvider, at indexPath: IndexPath, completion: @escaping SearchBlock) {
        guard playlistData.value.count > indexPath.row else {
            completion(.failure(.noResult))
            return
        }
        if let links = playlistData.value[indexPath.row].item.links {
            switch provider {
            case .itunes:
                completion(.success(links.apple))
            case .spotify:
                if let encodedSpotifyLink = links.spotify.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    completion(.success(encodedSpotifyLink))
                } else {
                    completion(.failure(.noResult))
                }
            }
        } else {
            completion(.failure(.noResult))
        }
    }

    // MARK: Internal methods

    fileprivate func fetchPlaylist(withPage page: Int) {
        self.playlistService.request(.playlist(page: page)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    let data = try response.map([PlaylistSong].self, using: Decoders.defaultKeysJSONDecoder, failsOnEmptyData: false)
                    if strongSelf.page == 1 {
                        let values = data
                            .map { PlaylistCellViewModel(with: $0) }
                        strongSelf.playlistData.accept(values)
                    } else {
                        var updatedValues = strongSelf.playlistData.value
                        updatedValues.append(contentsOf: data.map { PlaylistCellViewModel(with: $0) })
                        strongSelf.playlistData.accept(updatedValues)
                    }
                    strongSelf.page += 1
                    strongSelf.refresh.accept(false)
                    strongSelf.indicatorViewAnimating.accept(false)
                    strongSelf.initialLoad.accept(false)
                } catch {
                    Log.debug(error.localizedDescription)
                }
            case .failure(let error):
                Log.debug(error.localizedDescription)
            }
        }
    }

}
