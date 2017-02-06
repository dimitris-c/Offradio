//
//  RadioViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 06/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

final class RadioViewController: UIViewController, TabBarItemProtocol {

    
}

// MARK: TabBarItemProtocol
extension RadioViewController {
    
    func defaultTabBarItem() -> UITabBarItem {
        return UITabBarItem(title:"Search",
                            image:nil,
                            tag: TabIdentifier.listen.rawValue)
    }
    
}
