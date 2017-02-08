//
//  ScheduleViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ScheduleViewController: UIViewController {
    
    var tableView: UITableView!
    
    var viewModel: ScheduleViewModel!
    var delegate: ScheduleDelegate!
    var dataSource: ScheduleDataSource!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Schedule Offradio"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
        self.viewModel = ScheduleViewModel()
        
        self.tableView = UITableView()
        
        self.tableView.tableFooterView = UIView()
        
        self.delegate = ScheduleDelegate(withViewController: self)
        self.dataSource = ScheduleDataSource(withTableView: self.tableView)
        self.tableView.dataSource = self.dataSource
        
        self.view.addSubview(self.tableView)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
}

extension ScheduleViewController {
    
    func defaultTabBarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "",
                                image: UIImage(named: "schedule"),
                                selectedImage: UIImage(named: "schedule-selected"))
        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item.tag = TabIdentifier.schedule.rawValue
        return item
    }
    
}
