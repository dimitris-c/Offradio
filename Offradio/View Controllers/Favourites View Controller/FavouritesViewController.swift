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
import FirebaseAnalytics
import SwipeCellKit

final class FavouritesViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var actionBag = DisposeBag()
    
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
        
        self.viewModel.playlistData
            .drive(tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { [weak self] _, model, cell in
                cell.shownInFavouritesList = true
                cell.configure(with: model)
                cell.delegate = self
                cell.showSwipe(orientation: .right)
            }.disposed(by: disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
        
    }
    
}

extension FavouritesViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let handleAction: ((SwipeAction, IndexPath) -> Void) = { [weak self] action, indexPath in
            guard let self = self else { return }
            if let actionId = action.identifier,
               let provider = PlaylistCellSearchProvider(rawValue: actionId) {
                self.viewModel.search(on: provider, at: indexPath)
                    .subscribe(onNext: { result in
                        switch result {
                            case .success(let value):
                                if let url = URL(string: value) {
                                    UIApplication.shared.open(url)
                                }
                            case .failure(let error):
                                if error == .noResult {
                                    self.showAlert(title: "Ooops", message: "It seems that we couldn't find that song")
                                }
                        }
                        self.actionBag = DisposeBag()
                    }).disposed(by: self.actionBag)
            }
        }
        
        let itunesSeach = SwipeAction(style: .default, title: nil, handler: handleAction)
        let spotifySearch = SwipeAction(style: .default, title: nil, handler: handleAction)
        
        itunesSeach.identifier = PlaylistCellSearchProvider.itunes.rawValue
        itunesSeach.image = UIImage(named: "applemusic_icon")
        itunesSeach.font = UIFont.robotoRegular(withSize: 12)
        itunesSeach.backgroundColor = UIColor.black
        itunesSeach.highlightedBackgroundColor = UIColor.offRed
        
        spotifySearch.font = UIFont.leagueGothicRegular(withSize: 12)
        spotifySearch.image = UIImage(named: "spotify_icon")
        spotifySearch.identifier = PlaylistCellSearchProvider.spotify.rawValue
        spotifySearch.backgroundColor = UIColor.black
        spotifySearch.highlightedBackgroundColor = UIColor.offRed
        
        itunesSeach.transitionDelegate = ScaleTransition.default
        spotifySearch.transitionDelegate = ScaleTransition.default
        
        //        let item = self.viewModel.playlistData.value[indexPath.row].item
        var actions: [SwipeAction] = [spotifySearch, itunesSeach]
        //        if let links = item.links {
        //            if links.hasSpotify {
        //                actions.append(spotifySearch)
        //            }
        //            if links.hasAppleMusic {
        //                actions.append(itunesSeach)
        //            }
        //        }
        return actions
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.backgroundColor = .black
        options.transitionStyle = .reveal
        return options
    }
    
}
