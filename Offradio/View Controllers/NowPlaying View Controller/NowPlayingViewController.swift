//
//  NowPlayingViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NowPlayingViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var viewModel: NowPlayingViewModel!
    
    init(with radioMetadata: OffradioMetadata) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = NowPlayingViewModel(with: radioMetadata)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
