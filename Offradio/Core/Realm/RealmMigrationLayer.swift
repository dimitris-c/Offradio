//
//  RealmMigrationLayer.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RealmSwift

final class RealmMigrationLayer {
    
    class func performMigration() {
        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 2) {
            }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
}
