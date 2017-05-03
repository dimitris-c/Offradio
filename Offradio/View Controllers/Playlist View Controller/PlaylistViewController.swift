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
    
    fileprivate var initialLoadActivityView: UIActivityIndicatorView!
    fileprivate var tableViewActivityContainerView: UIView!
    fileprivate var tableViewActivityView: UIActivityIndicatorView!
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

        self.tableViewActivityContainerView = UIView(frame: .zero)
        self.tableViewActivityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.tableViewActivityContainerView.addSubview(self.tableViewActivityView)
        
        self.tableView = UITableView(frame: .zero)
        self.tableView.register(cellType: PlaylistTableViewCell.self)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = CGFloat.deviceValue(iPhone: 165, iPad: 195)
        self.tableView.tableFooterView = self.tableViewActivityContainerView
        self.view.addSubview(self.tableView)
        
        self.initialLoadActivityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.initialLoadActivityView.startAnimating()
        self.view.addSubview(self.initialLoadActivityView)
        
        let favouritesListButton = UIButton(type: .custom)
        favouritesListButton.setBackgroundImage(#imageLiteral(resourceName: "favourite-button-icon"), for: .normal)
        favouritesListButton.setBackgroundImage(#imageLiteral(resourceName: "favourite-button-icon-added"), for: .highlighted)
        favouritesListButton.sizeToFit()
        favouritesListButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.showFavouritesList()
            }).addDisposableTo(disposeBag)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouritesListButton)
        

        self.viewModel = PlaylistViewModel(viewWillAppear: rx.viewWillAppear.asDriver(),
                                           scrollViewDidReachBottom: tableView.rx.reachedBottom.asDriver())
        
        let identifier = PlaylistTableViewCell.identifier
        let cellType = PlaylistTableViewCell.self
        
        self.viewModel.playlistData.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { row, model, cell in
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
            .map { [weak self] _ in (self?.refreshControl.isRefreshing ?? false) }
            .bind(to: self.viewModel.refresh)
            .addDisposableTo(disposeBag)
        
        self.viewModel.refresh.asObservable()
            .bind(to: self.refreshControl.rx.isRefreshing)
            .addDisposableTo(disposeBag)
        
        self.viewModel.indicatorViewAnimating.asObservable()
            .bind(to: self.tableViewActivityView.rx.isAnimating)
            .addDisposableTo(disposeBag)
        
        self.viewModel.initialLoad.asObservable()
            .bind(to: self.initialLoadActivityView.rx.isAnimating)
            .addDisposableTo(disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    fileprivate final func showFavouritesList() {
        let favourites = FavouritesViewController()
        self.hideLabelOnBackButton()
        self.navigationController?.pushViewController(favourites, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
        
        self.tableViewActivityContainerView.frame.size.width = self.view.bounds.width
        self.tableViewActivityContainerView.frame.size.height = CGFloat.deviceValue(iPhone: 60, iPad: 80)
        self.tableViewActivityView.sizeToFit()
        self.tableViewActivityView.center = CGPoint(x: self.tableViewActivityContainerView.bounds.midX,
                                                    y: self.tableViewActivityContainerView.bounds.midY)
        
        
        self.initialLoadActivityView.sizeToFit()
        self.initialLoadActivityView.center = CGPoint(x: self.view.bounds.midX,
                                                      y: self.view.bounds.midY)
        
    }
    
}
