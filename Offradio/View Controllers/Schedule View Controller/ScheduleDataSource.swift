//
//  ScheduleDataSource.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

final class ScheduleDataSource: NSObject, UITableViewDataSource {
    
    weak var tableView: UITableView?
    
    init(withTableView tableView: UITableView?) {
        super.init()
        self.tableView = tableView
        
        self.tableView?.register(cellType: UITableViewCell.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
