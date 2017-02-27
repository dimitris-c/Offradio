//
//  ModelResult.swift
//  Offradio
//
//  Created by Dimitris C. on 25/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

struct ModelResult<Model> {
    let value: Model?
    let error: Error?
    
    func isSuccess() -> Bool {
        return value != nil
    }
    
    func isFailure() -> Bool {
        return error != nil
    }
}
