//
//  LastFMApiService.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Alamofire
import Omicron

struct LastFMAPIKey {
    static let apiKey: String = "afdc2c22f29208e54874cca3566b57ae"
}

struct LastFMImage {
    let url: String
    let size: String
    init(with json: JSON) {
        self.size = json["size"].stringValue
        self.url  = json["#text"].stringValue
    }
}

struct LastFMArtist {
    let images: [LastFMImage]
    init(with json: JSON) {
        self.images = json["image"].arrayValue.map { LastFMImage(with: $0) }
    }
}

enum LastFMAPIService: Service {
    case artistInfo(artist: String)
}

extension LastFMAPIService {
    var baseURL: URL { return URL(string: "https://ws.audioscrobbler.com/2.0/")! }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return ""
    }

    var params: RequestParameters {
        switch self {
        case .artistInfo(let artist):
            let data: Parameters = ["method": "artist.getinfo",
                                    "api_key": LastFMAPIKey.apiKey,
                                    "format": "json",
                                    "artist": artist]
            return RequestParameters(parameters: data)
        }
    }

}

final class LastFMAPIResponseParse: APIResponse<LastFMArtist> {
    override func toData(rawData data: JSON) -> LastFMArtist? {
        let artist = data["artist"]
        return LastFMArtist(with: artist)
    }
}
