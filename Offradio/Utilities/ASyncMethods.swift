//
//  Functions.swift
//  Offradio
//
//  Created by Dimitris C. on 23/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

/// Executes the given closure on a background thread
func dispatchAsync(_ closure:@escaping ()->()) {
    DispatchQueue.global(qos: .default).async(execute: closure)
}

/// Executes the given closure on the main thread
func dispatchMain(_ closure:@escaping ()->()) {
    DispatchQueue.main.async(execute: closure)
}

/// Executes the given closure on the main thread, using the passed delay value
func delayMain(_ delay:TimeInterval, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

/// Executes the given closure on a background thread, using the passed delay value
func delayAsync(_ delay:TimeInterval, closure:@escaping ()->()) {
    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.global(qos: .default).asyncAfter(deadline: deadline, execute: closure)
}
