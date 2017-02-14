//
//  PaginationResponseType.swift
//  Offradio
//
//  Created by Dimitris C. on 14/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

protocol PaginationResponse {
    associatedtype Element
    var elements: [Element] { get }
    var page: Int { get }
    var nextPage: Int? { get }
    init(elements: [Element], page: Int, nextPage: Int?)
}

struct AnyPaginationResponse<Element>: PaginationResponse {
    let elements: [Element]
    let page: Int
    let nextPage: Int?
    
    init<Response: PaginationResponse>(response: Response) where Response.Element == Element {
        elements = response.elements
        page = response.page
        nextPage = response.nextPage
    }
    
    init(elements: [Element], page: Int, nextPage: Int?) {
        self.elements = elements
        self.page = page
        self.nextPage = nextPage
    }
    
}
