//
//  UITableViewExtensions.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift

extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }

extension UITableView {
    // Registers a UITableViewCell subclass conforming to Reusable
    final func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(cellType.self, forCellReuseIdentifier: cellType.identifier)
    }
    
    final func register<T: UITableViewHeaderFooterView>(headerFooterType: T.Type) {
        self.register(headerFooterType.self, forHeaderFooterViewReuseIdentifier: headerFooterType.identifier)
    }

    final func dequeueReusableCell<T: UITableViewCell>(`for` indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self). ")
        }
        return cell
    }
}
