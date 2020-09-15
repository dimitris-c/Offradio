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
import SwiftyJSON

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
    let itunesService = MoyaProvider<iTunesSearchAPI>(plugins: [NetworkLoggerPlugin()])

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
        if let item = playlistData.value[indexPath.row].item {
            switch provider {
            case .itunes:
                searchOniTunes(for: item, completion: completion)
            case .spotify:
                searchOnSpotifty(for: item, completion: completion)
            }
        }
    }

    // MARK: Internal methods

    fileprivate func searchOniTunes(`for` item: PlaylistSong, completion: @escaping SearchBlock) {
        itunesService.request(.search(with: item)) { result in
            do {
                let data = try result.get().data
                let json = try JSON(data: data)
                if let urlString = json["results"].arrayValue.first?["trackViewUrl"].stringValue {
                    completion(.success(urlString))
                } else {
                    completion(.failure(.noResult))
                }
            } catch { }
        }
    }

    // Not yet implemented!
    fileprivate func searchOnSpotifty(`for` item: PlaylistSong, completion: SearchBlock) {

    }

    fileprivate func fetchPlaylist(withPage page: Int) {
        self.playlistService.request(.playlist(page: page)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    print(String(data: response.data, encoding: .utf8))
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
