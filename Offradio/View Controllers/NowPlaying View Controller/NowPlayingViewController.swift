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
    
    fileprivate var scrollView: UIScrollView!
    
    fileprivate var currentTrackViewInitialHeight: CGFloat = 0.0
    fileprivate var currentTrackView: CurrentTrackView!
    fileprivate var producerView: ProducerView!
    
    init(with radioMetadata: OffradioMetadata) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = NowPlayingViewModel(with: radioMetadata)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        
        self.scrollView = UIScrollView(frame: .zero)
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        self.currentTrackView = CurrentTrackView(with: self.viewModel.currentTrack.asDriver())
        self.scrollView.addSubview(self.currentTrackView)
        
        self.producerView = ProducerView(frame: .zero)
        self.scrollView.addSubview(self.producerView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.scrollView.frame = self.view.bounds
        
        let (currentTrackRect, remainderRect) = self.view.bounds.divided(atDistance: self.view.frame.height * 0.55,
                                                                         from: .minYEdge)
        self.currentTrackView.frame = currentTrackRect.integral
        self.producerView.frame = remainderRect.integral
     
        currentTrackViewInitialHeight = self.currentTrackView.frame.size.height
    }
    
}

extension NowPlayingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
//        if y > 0 {
            self.currentTrackView.frame.origin.y = scrollView.contentOffset.y
            self.currentTrackView.frame.size.height = currentTrackViewInitialHeight + y
//        }
    }
    
}
