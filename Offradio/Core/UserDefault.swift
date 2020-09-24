//
//  UserDefault.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 19/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation

@propertyWrapper
final class UserDefault<Value: UserDefaultValue> {
    let key: String
    let defaultValue: Value
    
    private var userDefaults: UserDefaults
    
    init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: Value {
        get {
            userDefaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }
}

@propertyWrapper
final class CodableUserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    
    private var userDefaults: UserDefaults
    
    init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: Value {
        get {
            guard let data = userDefaults.data(forKey: key) else { return defaultValue }
            guard let item = try? JSONDecoder().decode(Value.self, from: data) else {
                return defaultValue
            }
            return item
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.setValue(data, forKey: key)
        }
    }
}

protocol UserDefaultValue {}

extension Data: UserDefaultValue { }
extension String: UserDefaultValue { }
extension Date: UserDefaultValue { }
extension NSNumber: UserDefaultValue { }
extension Bool: UserDefaultValue { }
extension Int: UserDefaultValue { }
extension Int8: UserDefaultValue { }
extension Int16: UserDefaultValue { }
extension Int32: UserDefaultValue { }
extension Int64: UserDefaultValue { }
extension UInt: UserDefaultValue { }
extension UInt8: UserDefaultValue { }
extension UInt16: UserDefaultValue { }
extension UInt32: UserDefaultValue { }
extension UInt64: UserDefaultValue { }
extension Double: UserDefaultValue { }
extension Float: UserDefaultValue { }

extension Array: UserDefaultValue where Element: UserDefaultValue { }
extension Dictionary: UserDefaultValue where Key == String, Value: UserDefaultValue { }
