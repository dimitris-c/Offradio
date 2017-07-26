//
//  UITableViewExtensions.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift

extension UITableViewCell: Reusable { }

extension UITableView {
    // Registers a UITableViewCell subclass conforming to Reusable
    final func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        self.register(cellType.self, forCellReuseIdentifier: cellType.identifier)
    }

    final func dequeueReusableCell<T: UITableViewCell>(`for` indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self). ")
        }
        return cell
    }
}
