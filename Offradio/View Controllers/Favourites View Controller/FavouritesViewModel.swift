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
import Moya

final class FavouritesViewModel {
    
    let favouritesDataLayer: PlaylistFavouritesLayer = PlaylistFavouritesLayer()
    let data: Observable<[PlaylistSong]>
    let playlistData: Driver<[PlaylistCellViewModel]>
    
    let itunesService = MoyaProvider<iTunesSearchAPI>()
    
    init(viewWillAppear: Driver<Void>) {
        
        if let favourites = favouritesDataLayer.allFavourites()?.sorted(byKeyPath: "airedDatetime", ascending: false) {
            self.data = Observable.array(from: favourites)
                .share(replay: 1, scope: .whileConnected)
            playlistData = data
                .map { $0.map { PlaylistCellViewModel(with: $0) } }
                .asDriver(onErrorJustReturn: [])
        } else {
            self.data = .empty()
            playlistData = .empty()
        }
        
    }
    
    
    func search(on provider: PlaylistCellSearchProvider, at indexPath: IndexPath) -> Observable<Result<String, SearchResultError>> {
        return self.data.flatMap { songs -> Observable<Result<String, SearchResultError>> in
            guard songs.count > indexPath.row else {
                return .just(.failure(.noResult))
            }
            if let links = songs[indexPath.row].links {
                switch provider {
                    case .itunes:
                        return self.searchOniTunes(for: songs[indexPath.row])
                    case .spotify:
                        if let encodedSpotifyLink = links.spotify.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                            return .just(.success(encodedSpotifyLink))
                        } else {
                            return .just(.failure(.noResult))
                        }
                }
            } else {
                return .just(.failure(.noResult))
            }
        }
    }
    
    
    private func searchOniTunes(for item: PlaylistSong) -> Observable<Result<String, SearchResultError>> {
        return itunesService.rx.request(.search(with: item))
            .map { response in
                do {
                    let data = response.data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                        if let results = json["results"] as? [[String: Any]],
                           let trackView = results.first?["trackViewUrl"] as? String {
                            
                            return .success(trackView)
                        } else {
                            return .failure(.noResult)
                        }
                    }
                    else {
                        return .failure(.noResult)
                    }
                } catch {
                    return .failure(.noResult)
                }
            }.catchErrorJustReturn(.failure(.noResult))
            .asObservable()
    }
}
