//
//  ScheduleDelegate.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

final class ScheduleDelegate: NSObject, UITableViewDelegate {
    
    weak var viewController: UIViewController?
    
    init(withViewController viewController: UIViewController) {
        super.init()
        
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        Log.debug("selected row at: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
