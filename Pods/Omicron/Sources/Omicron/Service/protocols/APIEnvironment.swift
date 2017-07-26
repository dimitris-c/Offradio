//
//  APIEnvironment.swift
//
//  Created by Dimitris Chatzieleftheriou on 24/05/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

public protocol APIEnvironment {
    static var current: String { get }
}
