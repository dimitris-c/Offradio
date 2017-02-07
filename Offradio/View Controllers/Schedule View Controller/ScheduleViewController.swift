//
//  ScheduleViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    
    
}

extension ScheduleViewController {
    
    func defaultTabBarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "",
                                image: UIImage(named: "schedule"),
                                selectedImage: UIImage(named: "schedule-selected"))
        item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        item.tag = TabIdentifier.schedule.rawValue
        return item
    }
    
}
