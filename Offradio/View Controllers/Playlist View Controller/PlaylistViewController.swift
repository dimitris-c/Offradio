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

        self.viewModel = PlaylistViewModel()
        
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

        self.viewModel.playlistData.asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { row, model, cell  in
                cell.configure(with: model)
            }.addDisposableTo(disposeBag)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
}
