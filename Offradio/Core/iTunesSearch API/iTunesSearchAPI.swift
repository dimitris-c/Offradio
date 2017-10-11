//
//  iTunesSearchAPI.swift
//  Offradio
//
//  Created by Dimitris C. on 18/09/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import Moya

enum iTunesSearchAPI: TargetType {
    case search(with: PlaylistSong)
}

extension iTunesSearchAPI {
    var baseURL: URL { return URL(string: "https://itunes.apple.com/search")! }

    var method: Moya.Method {
        return .get
    }

    var path: String {
        switch self {
        case .search(let song):
            let locale = Locale.current.regionCode ?? ""
            let charset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789?&=.-_*+/: ").inverted
            let sanitisedArtist = song.artist.replacingOccurrences(of: " ", with: "+").components(separatedBy: charset).joined(separator: "")
            let sanitisedSongTitle = song.songTitle.replacingOccurrences(of: " ", with: "+").components(separatedBy: charset).joined(separator: "")
            return "?country=\(locale)&media=music&app=music&entity=song&term=\(sanitisedArtist)+\(sanitisedSongTitle)&artistTerm=\(sanitisedArtist)&songTerm=\(sanitisedSongTitle)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
    }

    var task: Task {
        return .requestPlain
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return nil
    }
}
