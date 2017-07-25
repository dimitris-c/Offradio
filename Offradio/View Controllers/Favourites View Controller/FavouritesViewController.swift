//
//  FavouritesViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 21/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FavouritesViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    fileprivate var viewModel: FavouritesViewModel!
    
    fileprivate var initialLoadActivityView: UIActivityIndicatorView!
    fileprivate var tableViewActivityContainerView: UIView!
    fileprivate var tableViewActivityView: UIActivityIndicatorView!
    fileprivate var tableView: UITableView!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Favourites"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightBlack
        
        self.tableView = UITableView(frame: .zero)
        self.tableView.register(cellType: PlaylistTableViewCell.self)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = CGFloat.deviceValue(iPhone: 165, iPad: 195)
        self.tableView.tableFooterView = self.tableViewActivityContainerView
        self.view.addSubview(self.tableView)
        
        self.viewModel = FavouritesViewModel(viewWillAppear: rx.viewWillAppear.asDriver())
        
        let identifier = PlaylistTableViewCell.identifier
        let cellType = PlaylistTableViewCell.self
        
        self.viewModel.playlistData.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { row, model, cell in
                cell.shownInFavouritesList = true
                cell.configure(with: model)
            }.addDisposableTo(disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
        
    }

}
