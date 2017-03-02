//
//  CurrentTrackView.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage

final class CurrentTrackView: UIView {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var albumArtwork: UIImageView!
    fileprivate var bottomGradient: UIView!
    
    init(with currentTrack: Driver<CurrentTrack>) {
        super.init(frame: .zero)
        
        self.albumArtwork = UIImageView(image: #imageLiteral(resourceName: "artwork-image-placeholder"))
        self.addSubview(self.albumArtwork)
        
        currentTrack.asObservable()
            .map { $0.image }
            .subscribe(onNext: { [weak self] image in
                if let url = URL(string: image) {
                    self?.albumArtwork.sd_setImage(with: url)
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.albumArtwork.frame = self.bounds
        
    }
    
}
