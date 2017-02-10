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
    
    var activityIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Schedule"        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
        let date = Date()
        if let weekDay = date.dayOfWeek() {
            self.navigationItem.title = "Schedule - \(weekDay)"
        }
        
        self.viewModel = ScheduleViewModel()
        
        self.tableView = UITableView()
        self.tableView.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
        self.tableView.register(cellType: ScheduleTableViewCell.self)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.delegate = ScheduleDelegate(withViewController: self, dataSource: self.viewModel)
        self.tableView.delegate = self.delegate
        
        self.view.addSubview(self.tableView)
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
        
        let identifier = ScheduleTableViewCell.identifier
        let cellType = ScheduleTableViewCell.self
        
        self.viewModel.schedule.asObservable().bindTo(tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { row, item, cell in
            cell.configure(with: item)
        }.addDisposableTo(disposeBag)
        
        self.refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView?.addSubview(refreshControl)
            tableView.sendSubview(toBack: refreshControl)
        }
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in (self?.refreshControl.isRefreshing ?? true) }
            .bindTo(self.viewModel.refresh)
            .addDisposableTo(disposeBag)
        
        self.viewModel.refresh.asObservable().bindTo(self.refreshControl.rx.isRefreshing).addDisposableTo(disposeBag)
        self.viewModel.firstLoad.asObservable().bindTo(self.activityIndicator.rx.isAnimating).addDisposableTo(disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
        
        self.activityIndicator.sizeToFit()
        self.activityIndicator.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
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
