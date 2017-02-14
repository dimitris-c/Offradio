//
//  SearchResponse.swift
//  Offradio
//
//  Created by Dimitris C. on 14/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

struct Response<Element>: PaginationResponse {
    let elements: [Element]
    let page: Int
    let nextPage: Int?
}
