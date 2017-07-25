//
//  ContactViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MessageUI

final class ContactViewController: UIViewController, TabBarItemProtocol {
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    fileprivate var tableView: UITableView!
    fileprivate var contactViewModel: ContactViewModel!
    
    fileprivate var funkytapsLogo: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Contact Offradio"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Why use storyboards, it's easy")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightBlack
        
        self.contactViewModel = ContactViewModel()
        
        self.tableView = UITableView(frame: .zero)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.rowHeight = CGFloat.deviceValue(iPhone: 80, iPad: 120)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.register(cellType: ContactTableViewCell.self)
        
        self.view.addSubview(self.tableView)
        
        self.funkytapsLogo = UIButton(type: .custom)
        self.funkytapsLogo.setBackgroundImage(#imageLiteral(resourceName: "created-by-funkytaps"), for: .normal)
        
        self.funkytapsLogo.rx.tap.subscribe(onNext: {
            UIApplication.open(url: URL(string: "https://www.niceandneat.gr")!)
        }).addDisposableTo(disposeBag)
        
        self.view.addSubview(self.funkytapsLogo)
        
        let cellIdentifier = ContactTableViewCell.identifier
        let cellType = ContactTableViewCell.self
        self.contactViewModel.data.asObservable().bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { row, model, cell in
            cell.configure(with: model)
        }.addDisposableTo(disposeBag)
        
        self.tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            if let item = self?.contactViewModel.getItem(at: indexPath) {
                self?.showView(for: item.type)
            }
        }).addDisposableTo(disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Since the data source is fixed then we just need to fit the height of the table based on
        // the data source items
        let height = CGFloat(self.contactViewModel.data.value.count) * self.tableView.rowHeight
        self.tableView.frame.size = CGSize(width: self.view.frame.width, height: height)
        
        self.funkytapsLogo.sizeToFit()
        self.funkytapsLogo.center.x = self.view.center.x
        self.funkytapsLogo.frame.origin.y = self.tableView.frame.maxY + ((self.view.frame.height - self.tableView.frame.maxY) - self.funkytapsLogo.frame.height) * 0.5
    }
    
    final fileprivate func showView(`for` type: ContactItemType) {
        switch type {
        case .facebook:
            self.showFacebookPage()
            break
        case .twitter:
            self.showTwitterPage()
            break
        case .email:
            self.showEmail()
            break
        case .visit:
            self.visitOffradio()
            break
        }
    }
    
    final fileprivate func showFacebookPage() {
        guard let url = URL(string: "https://www.facebook.com/turnyourradiooff"),
            let directUrl = URL(string: "fb://profile/26061842985") else {
            return
        }
        
        let directOpened = UIApplication.open(url: directUrl)
        if !directOpened {
            UIApplication.open(url: url)
        }
        
    }
    
    final fileprivate func showTwitterPage() {
        guard let url = URL(string: "http://www.twitter.com/offradio"),
            let directUrl = URL(string: "twitter://user?screen_name=offradio") else {
                return
        }
        
        let directOpened = UIApplication.open(url: directUrl)
        if !directOpened {
            UIApplication.open(url: url)
        }
    }
    
    final fileprivate func showEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.setToRecipients(["studio@offradio.gr"])
            mailController.setSubject("I'm listening to OFFRadio!")
            mailController.navigationBar.tintColor = UIColor.white
            mailController.navigationBar.barTintColor = self.view.backgroundColor
            mailController.mailComposeDelegate = self
            self.navigationController?.present(mailController, animated: true, completion: { [weak mailController] in
                mailController?.becomeFirstResponder()
            })
        }
    }
    
    final fileprivate func visitOffradio() {
        guard let url = URL(string: "http://www.offradio.gr")else {
            return
        }
        UIApplication.open(url: url)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension MFMailComposeViewController {
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return nil
    }
}

extension ContactViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            Log.debug("message sent")
        }
        
        controller.dismiss(animated: true, completion: nil)
        controller.resignFirstResponder()
    }
    
}

extension ContactViewController {
    func defaultTabBarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "", image: UIImage(named: "speak"), selectedImage: UIImage(named: "speak-selected"))
        item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        item.tag = TabIdentifier.contact.rawValue
        return item
    }
}
