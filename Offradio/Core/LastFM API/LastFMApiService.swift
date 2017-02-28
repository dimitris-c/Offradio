//
//  LastFMApiService.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import SwiftyJSON
import Alamofire

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
        self.images = json["image"].map { LastFMImage(with: $1) }
    }
}

final class LastFMApiService: APIService<LastFMArtist> {
    fileprivate let apiPath = "https://ws.audioscrobbler.com/2.0/"
    fileprivate let apiKey = "afdc2c22f29208e54874cca3566b57ae"
    init(with artist: String) {
        let params = ["method"  : "artist.getinfo",
                      "api_key" : apiKey,
                      "format"  : "json",
                      "artist"  : artist]
        let parameters = RequestParameters(parameters: params, encoding: URLEncoding.default)
        let request = APIRequest(apiPath: "", method: .get, parameters: parameters)
        super.init(request: request, parse: LastFMAPIResponseParse())
    }
    
}

final class LastFMAPIResponseParse: APIResponse<LastFMArtist> {
    override func toData(rawData data: JSON) -> LastFMArtist? {
        return LastFMArtist(with: data)
    }
}
