//
//  ContentLoadingViewController.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import UIKit

class ContentLoadingViewController: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private lazy var activityLabel = UILabel()
    private var loadingTitle: String?
    
    init(with loadingTitle: String?) {
        super.init(nibName: nil, bundle: nil)
        self.loadingTitle = loadingTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightBlack
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityLabel)
        self.activityLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.activityLabel.textAlignment = .center
        self.activityLabel.numberOfLines = 0
        self.activityLabel.text = self.loadingTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.stopAnimating()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let ownCenter = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        self.activityIndicator.center = ownCenter
        self.activityLabel.frame.size.width = self.view.bounds.width - CGFloat.deviceValue(iPhone: 20, iPad: 40)
        self.activityLabel.sizeToFit()
        self.activityLabel.frame.size.width = self.view.bounds.width - CGFloat.deviceValue(iPhone: 20, iPad: 40)
        self.activityLabel.frame.origin.y = self.activityIndicator.frame.maxY + 10
        self.activityLabel.center.x = ownCenter.x
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
