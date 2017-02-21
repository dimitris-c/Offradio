//
//  DataLayer.swift
//  Offradio
//
//  Created by Dimitris C. on 17/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RealmSwift

enum DataAccessError: Error {
    case Insert
    case Deletion
    case Read
    case Write
    case Connection
}

protocol DataLayerProtocol {
    func database() throws -> Realm
    func create(item anItem: Object, update: Bool) throws
}

extension DataLayerProtocol {
    func database() throws -> Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            throw DataAccessError.Connection
        }
    }
    
    func create<Item: Object>(item anItem: Item, update: Bool) throws {
        let realm = try database()
        do {
            try realm.write {
                realm.add(anItem)
            }
        } catch {
            throw DataAccessError.Insert
        }
    }
    
}
