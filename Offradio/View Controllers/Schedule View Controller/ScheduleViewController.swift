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
import FirebaseAnalytics

final class ScheduleViewController: UIViewController {

    let disposeBag: DisposeBag = DisposeBag()

    var tableView: UITableView!

    var viewModel: ScheduleViewModel!

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
        self.view.backgroundColor = UIColor.lightBlack

        let date = Date()
        if let weekDay = date.dayOfWeek() {
            self.navigationItem.title = "Schedule - \(weekDay)"
        }

        self.viewModel = ScheduleViewModel()

        self.tableView = UITableView()
        self.tableView.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
        self.tableView.register(cellType: ScheduleTableViewCell.self)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.seperatorColor
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = CGFloat.deviceValue(iPhone: 60, iPad: 90)
        self.view.addSubview(self.tableView)

        self.registerForPreviewing(with: self, sourceView: self.tableView)

        self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)

        let identifier = ScheduleTableViewCell.identifier
        let cellType = ScheduleTableViewCell.self

        self.viewModel.navigationTitle.asObservable()
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)

        self.viewModel.schedule.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { _, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)

        self.tableView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] indexPath in
            guard let sSelf = self else { return }
            sSelf.tableView.deselectRow(at: indexPath, animated: true)
            let item = sSelf.viewModel.getSchedule(at: indexPath)
            if let producerId = item.producerId, let bio = sSelf.viewModel.getProducerBio(for: producerId) {
                sSelf.showProducerBio(with: bio)
            }
        }).disposed(by: disposeBag)

        self.configureRefreshControl()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.tableView.frame = self.view.bounds

        self.activityIndicator.sizeToFit()
        self.activityIndicator.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)

    }

    private func configureRefreshControl() {
        self.refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView?.addSubview(refreshControl)
            tableView.sendSubviewToBack(refreshControl)
        }

        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in (self?.refreshControl.isRefreshing ?? true) }
            .bind(to: self.viewModel.refresh)
            .disposed(by: disposeBag)

        self.viewModel.refresh.asObservable()
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        self.viewModel.firstLoad.asObservable()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

    }

    private func showProducerBio(with producer: Producer1) {
        self.hideLabelOnBackButton()
        let producerBioViewController = ProducersBioViewController(with: producer)
        self.navigationController?.pushViewController(producerBioViewController, animated: true)
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

extension ScheduleViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }

        let item = viewModel.getSchedule(at: indexPath)
        if item.hasBio, let bio = viewModel.getProducerBio(for: item.showTitle) {

            let producerBioViewController = ProducersBioViewController(with: bio)
            let cellRect = tableView.rectForRow(at: indexPath)
            let sourceRect = previewingContext.sourceView.convert(cellRect, to: tableView)
            previewingContext.sourceRect = sourceRect

            return producerBioViewController
        }

        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.hideLabelOnBackButton()
        show(viewControllerToCommit, sender: self)
    }

}
