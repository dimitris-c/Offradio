//
//  SettingsViewController.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 19/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SettingsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: SettingsViewModel
    
    private let tableView: UITableView
    private let dataSource = SettingsDataSource()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.tableView = UITableView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.title = "App Settings"
        
        self.setupUI()
        self.setupBindings()
    }
    
    private func setupUI() {
        
        self.view.addSubview(self.tableView)
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = UIColor.lightBlack
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.allowsMultipleSelection = false
        self.tableView.allowsSelection = true
        self.tableView.separatorColor = .lightBlack
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(cellType: SettingsToggableTableViewCell.self)
        self.tableView.register(cellType: SettingsSelectableTableViewCell.self)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func setupBindings() {
        
        let cellActions = dataSource.actions.asObservable()
        let itemSelected = tableView.rx.itemSelected
            .flatMap { indexPath -> Observable<(IndexPath, SettingsSectionItem)> in
                return Observable.just(try self.tableView.rx.model(at: indexPath))
                    .map { (indexPath, $0) }
            }.map({ indexPath, model -> SettingsAction in
                if case let .selectable(type, oldValue, _) = model {
                    return SettingsAction.select(type: type, indexPath: indexPath, newValue: !oldValue)
                }
                return .none
            })
        
        let actions = Observable.merge(cellActions, itemSelected)
        
        let items = viewModel.connect(actions: actions)
        
            items
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        

    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) {
            return cell.selectionStyle != .none
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .lightenBlack
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.tintColor = .lightBlack
            view.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            view.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

final class SettingsDataSource: RxTableViewSectionedReloadDataSource<SettingsSectionModel> {
    
    let actions = PublishRelay<SettingsAction>()
    
    init() {
        super.init(configureCell: { _, _, _, _ -> UITableViewCell in return UITableViewCell() })
        
        self.configureCell = { [actions] dataSource, tableView, indexPath, _ in
            switch dataSource[indexPath] {
                case .toggable(let type, let value):
                    let cell: SettingsToggableTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.configure(with: type.title, value: value)
                    cell.toggleSwitch.rx
                        .value
                        .changed
                        .map { bool in
                            SettingsAction.toggle(type: type, indexPath: indexPath, newValue: bool)
                        }
                        .bind(to: actions)
                        .disposed(by: cell.disposeBag)
                    return cell
                case .selectable(let type, let value, let enabled):
                    let cell: SettingsSelectableTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.configure(with: type.title, value: value, enabled: enabled)
                    return cell
            }
        }
        
        self.titleForHeaderInSection = { dataSource, index in
            let section = dataSource[index]
            return section.title
        }
        
    }
    
}
