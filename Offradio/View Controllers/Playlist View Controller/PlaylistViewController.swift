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
import SwipeCellKit
import FirebaseAnalytics

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

    // swiftlint:disable function_body_length
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightBlack

        self.tableViewActivityContainerView = UIView(frame: .zero)
        self.tableViewActivityView = UIActivityIndicatorView(style: .white)
        self.tableViewActivityContainerView.addSubview(self.tableViewActivityView)

        self.tableView = UITableView(frame: .zero)
        self.tableView.register(cellType: PlaylistTableViewCell.self)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = CGFloat.deviceValue(iPhone: 165, iPad: 200)
        self.tableView.tableFooterView = self.tableViewActivityContainerView
        self.view.addSubview(self.tableView)

        self.initialLoadActivityView = UIActivityIndicatorView(style: .whiteLarge)
        self.initialLoadActivityView.startAnimating()
        self.view.addSubview(self.initialLoadActivityView)

        let favouritesListButton = UIButton(type: .custom)
        favouritesListButton.setBackgroundImage(#imageLiteral(resourceName: "favourite-button-icon"), for: .normal)
        favouritesListButton.setBackgroundImage(#imageLiteral(resourceName: "favourite-button-icon-added"), for: .highlighted)
        favouritesListButton.sizeToFit()
        favouritesListButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
                self?.showFavouritesList()
            }).disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouritesListButton)

        self.viewModel = PlaylistViewModel(viewWillAppear: rx.viewWillAppear.asDriver(),
                                           scrollViewDidReachBottom: tableView.rx.reachedBottom.asDriver())

        let identifier = PlaylistTableViewCell.identifier
        let cellType = PlaylistTableViewCell.self

        self.viewModel.playlistData.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { _, model, cell in
                cell.configure(with: model)
                cell.delegate = self
                cell.showSwipe(orientation: .right)
            }.disposed(by: disposeBag)

        self.refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView?.addSubview(refreshControl)
            tableView.sendSubviewToBack(refreshControl)
        }

        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in (self?.refreshControl.isRefreshing ?? false) }
            .bind(to: self.viewModel.refresh)
            .disposed(by: disposeBag)

        self.viewModel.refresh.asObservable()
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        self.viewModel.indicatorViewAnimating.asObservable()
            .bind(to: self.tableViewActivityView.rx.isAnimating)
            .disposed(by: disposeBag)

        self.viewModel.initialLoad.asObservable()
            .bind(to: self.initialLoadActivityView.rx.isAnimating)
            .disposed(by: disposeBag)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
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

extension PlaylistViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let handleAction: ((SwipeAction, IndexPath) -> Void) = { [weak self] action, indexPath in
            guard let sSelf = self else { return }
            if let actionId = action.identifier,
                let provider = PlaylistCellSearchProvider(rawValue: actionId) {
                sSelf.viewModel.search(on: provider, at: indexPath) { result in
                    switch result {
                    case .success(let value):
                        if let url = URL(string: value) {
                            UIApplication.shared.open(url)
                        }
                    case .failure(let error):
                        if error == .noResult {
                            sSelf.showAlert(title: "Error", message: "Could not find song on iTunes.")
                        }
                    }
                }
            }
        }

        let itunesSeach = SwipeAction(style: .default, title: "Search on iTunes", handler: handleAction)
        let spotifySearch = SwipeAction(style: .default, title: "Spotify", handler: handleAction)

        itunesSeach.identifier = PlaylistCellSearchProvider.itunes.rawValue
        itunesSeach.font = UIFont.letterGothicBold(withSize: 15)
        itunesSeach.backgroundColor = UIColor.black
        itunesSeach.highlightedBackgroundColor = UIColor.offRed

        spotifySearch.font = UIFont.leagueGothicRegular(withSize: 15)
        spotifySearch.identifier = PlaylistCellSearchProvider.spotify.rawValue
        spotifySearch.backgroundColor = UIColor.black

        itunesSeach.transitionDelegate = ScaleTransition.default
        spotifySearch.transitionDelegate = ScaleTransition.default

        return [itunesSeach]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.backgroundColor = .black
        options.transitionStyle = .reveal
        return options
    }

}
