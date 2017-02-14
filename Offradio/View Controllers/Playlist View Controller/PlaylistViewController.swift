//
//  PlaylistViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 11/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PlaylistViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    fileprivate var viewModel: PlaylistViewModel!
    
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Playlist"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)

        
        self.tableView = UITableView(frame: .zero)
        self.tableView.register(cellType: PlaylistTableViewCell.self)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = CGFloat.deviceValue(iPhone: 165, iPad: 195)
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        
        let identifier = PlaylistTableViewCell.identifier
        let cellType = PlaylistTableViewCell.self

        self.viewModel = PlaylistViewModel(viewWillAppear: rx.viewWillAppear.asDriver(),
                                           scrollViewDidReachBottom: tableView.rx.reachedBottom.asDriver())
        
        
        self.viewModel.playlistData.asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { row, model, cell  in
                cell.configure(with: model)
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
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
}
