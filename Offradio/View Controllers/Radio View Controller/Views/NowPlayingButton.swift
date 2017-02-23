//
//  NowPlayingButton.swift
//  Offradio
//
//  Created by Dimitris C. on 23/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import AutoScrollLabel

final class NowPlayingButton: UIControl {
    
    final fileprivate let disposeBag = DisposeBag()
    
    final fileprivate var backgroundImageView: UIImageView!
    final fileprivate var scrollLabel: CBAutoScrollLabel!
    
    final let title: Variable<String> = Variable<String>("")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "nowplaying-button"),
                                               highlightedImage: #imageLiteral(resourceName: "nowplaying-button-selected"))
        self.backgroundImageView.sizeToFit()
        self.addSubview(self.backgroundImageView)
        
        let scrollLabelOffset: CGFloat = CGFloat.deviceValue(iPhone: 20, iPad: 24)
        let scrollLabelSize = CGSize(width: self.backgroundImageView.frame.width - scrollLabelOffset,
                                     height: self.backgroundImageView.frame.height)
        
        self.scrollLabel = CBAutoScrollLabel(frame: CGRect(origin: .zero, size: scrollLabelSize))
        self.scrollLabel.animationOptions = .curveLinear
        self.scrollLabel.labelSpacing = 30
        self.scrollLabel.scrollSpeed = 25
        self.scrollLabel.pauseInterval = 4.2
        self.scrollLabel.fadeLength = 4
        self.scrollLabel.textAlignment = .left
        self.scrollLabel.font = UIFont.letterGothicBold(withSize: CGFloat.deviceValue(iPhone: 18, iPad: 20))
        self.scrollLabel.textColor = UIColor.white
        self.addSubview(self.scrollLabel)
        
        
        
        self.title.asObservable().subscribe(onNext: { title in
            self.scrollLabel.setText(title, refreshLabels: true)
        }).addDisposableTo(disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundImageView.sizeToFit()
        
        self.scrollLabel.sizeToFit()
        self.scrollLabel.frame.origin = CGPoint(x: 30, y: 11)
        
    }
    
}
