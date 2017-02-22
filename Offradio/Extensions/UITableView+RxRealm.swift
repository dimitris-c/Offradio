//
//  UITableView+RxRealm.swift
//  Offradio
//
//  Created by Dimitris C. on 22/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxCocoa
import RxRealm


// MARK: RxSwift
extension UITableView {
    func apply(changeSet changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}
