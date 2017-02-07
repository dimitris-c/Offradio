//
//  ContactViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

final class ContactViewController: UIViewController, TabBarItemProtocol {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Contact Offradio"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
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
