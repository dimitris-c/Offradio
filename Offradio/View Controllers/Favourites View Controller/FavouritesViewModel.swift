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
    
    let favouritesDataLayer: PlaylistFavouritesLayer = PlaylistFavouritesLayer()
    let data: Observable<[PlaylistSong]>
    let playlistData: Driver<[PlaylistCellViewModel]>

    init(viewWillAppear: Driver<Void>) {
        
        if let favourites = favouritesDataLayer.allFavourites() {
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
                        if let encodedAppleLink = links.apple.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                            return .just(.success(encodedAppleLink))
                        } else {
                            return .just(.failure(.noResult))
                        }
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
}
