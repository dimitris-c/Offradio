//
//  PlayerCircleContainerView.swift
//  Offradio
//
//  Created by Dimitris C. on 07/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PlayerCircleContainerView: UIView, ToggleViewDelegate {
    
    let disposeBag = DisposeBag()
    
    let switched: PublishSubject<Bool> = PublishSubject<Bool>()
    let buffering: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
    
    @IBOutlet weak var bufferBackground: UIImageView!
    @IBOutlet weak var offradioLogo: UIImageView!
    fileprivate final let gredRedImageSizeiPad: CGSize = CGSize(width: 370, height: 370)
    fileprivate final var greyBackgroundView: UIImageView!
    fileprivate final var redBackgroundView: UIImageView!
    fileprivate final var offradioSwitch: ToggleView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.greyBackgroundView = UIImageView(image: #imageLiteral(resourceName: "player-grey-circle-background"))
        self.greyBackgroundView.contentMode = .scaleAspectFit
        self.addSubview(self.greyBackgroundView)
        
        self.redBackgroundView = UIImageView(image: #imageLiteral(resourceName: "player-red-circle-background"))
        self.redBackgroundView.contentMode = .scaleAspectFit
        self.redBackgroundView.alpha = 0.0
        self.redBackgroundView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.addSubview(self.redBackgroundView)
        
        let frame = CGRect(x: 0, y: 0, width: 320, height: 85)
        self.offradioSwitch = ToggleView(frame: frame,
                                         toggleViewType: ToggleViewTypeNoLabel,
                                         toggleBaseType: ToggleBaseTypeChangeImage,
                                         toggleButtonType: ToggleButtonTypeChangeImage)
        self.offradioSwitch.toggleDelegate = self
        self.addSubview(self.offradioSwitch)
        
        buffering.asObservable().subscribe(onNext: { (buffering) in
            if buffering {
                self.startBuffering()
            } else {
                self.stopBuffering()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
    }
    
    func setupViews() {
        self.bufferBackground.alpha = 0.0
    }
    
    func rearrangeViews() {
        self.bringSubview(toFront: offradioLogo)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.greyBackgroundView.sizeToFit()
        if DeviceType.IS_IPAD {
            self.greyBackgroundView.frame.size = gredRedImageSizeiPad
        }
        self.greyBackgroundView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        self.redBackgroundView.sizeToFit()
        if DeviceType.IS_IPAD {
            self.redBackgroundView.frame.size = gredRedImageSizeiPad
        }
        self.redBackgroundView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        self.offradioSwitch.sizeToFit()
        let x = (self.frame.width - self.offradioSwitch.frame.width) * 0.5
        let y = self.offradioLogo.frame.maxY + 12
        self.offradioSwitch.frame = CGRect(x: x, y: y,
                                           width: self.offradioSwitch.frame.width,
                                           height: self.offradioSwitch.frame.height)
        
    }
    
    func startBuffering() {
        Log.debug("start visual bufferring")
    }
    
    func stopBuffering() {
        Log.debug("stop visual bufferring")
    }
    
    // MARK: ToggleViewDelegate
    func selectLeftButton() {
        switched.onNext(false)
    }
    
    func selectRightButton() {
        switched.onNext(true)
    }
}
