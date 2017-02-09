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
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var tableView: UITableView!
    
    var viewModel: ScheduleViewModel!
    var delegate: ScheduleDelegate!
    
    var refreshControl: UIRefreshControl!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Schedule Offradio"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
        self.viewModel = ScheduleViewModel()
        
        self.tableView = UITableView()
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.register(cellType: ScheduleTableViewCell.self)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.delegate = ScheduleDelegate(withViewController: self)
        self.tableView.delegate = self.delegate
        
        self.view.addSubview(self.tableView)
        
        let identifier = ScheduleTableViewCell.identifier
        let cellType = ScheduleTableViewCell.self
        
        self.viewModel.schedule.bindTo(tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { row, item, cell in
            cell.textLabel?.text = item.timeTitle
            cell.detailTextLabel?.text = item.title.uppercased()
        }.addDisposableTo(disposeBag)
        
        self.refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView?.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
        
        self.viewModel.refresh.asObservable().bindTo(self.refreshControl.rx.isRefreshing).addDisposableTo(disposeBag)
        
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
