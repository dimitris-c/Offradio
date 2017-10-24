//
//  Log.swift
//  Offradio
//
//  Created by Dimitris C. on 23/01/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import SwiftyBeaver

//swiftlint:disable identifier_name
let Log = SwiftyBeaver.self
//swiftlint:enable identifier_name

//open class Log {
//
//    public final class func debug(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
//        let fileNameWithExtension: String = NSString(string: NSString(format: "%@", file).lastPathComponent).deletingPathExtension
//        printMessage("\(fileNameWithExtension) \(function) [\(line)]: \(message)")
//        log.debug(message)
//    }
//
//    public final class func error(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
//        let fileNameWithExtension: String = NSString(format: "%@", file).lastPathComponent
//        printMessage("ERROR: - \(fileNameWithExtension) \(function) [\(line)]: \(message)")
//        log.error(message)
//    }
//
//    public final class func warning(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
//        let fileNameWithExtension: String = NSString(format: "%@", file).lastPathComponent
//        printMessage("WARNING: - \(fileNameWithExtension) \(function) [\(line)]: \(message)")
//        log.warning(message)
//    }
//
//    fileprivate final class func printMessage(_ message: String) {
//        #if DEBUG
//            print("\(message)")
//        #else
//
//        #endif
//    }
//
//}
