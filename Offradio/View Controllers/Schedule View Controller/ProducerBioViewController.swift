//
//  ProducerBioViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 09/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

final class ProducersBioViewController: UIViewController {
    
    fileprivate var bio: Producer!
    
    init(with bio: Producer) {
        super.init(nibName: nil, bundle: nil)
        self.bio = bio
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
