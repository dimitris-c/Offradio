//
//  PlayerCircleContainerView.swift
//  Offradio
//
//  Created by Dimitris C. on 07/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift

final class PlayerCircleContainerView: UIView {
    
    let switched: Variable<Bool> = Variable<Bool>(false)
    
    @IBOutlet weak var bufferBackground: UIImageView!
    @IBOutlet weak var offradioLogo: UIImageView!
    
    fileprivate final var greyBackgroundView: UIImageView!
    fileprivate final var redBackgroundView: UIImageView!
    fileprivate final var offradioSwitch: SevenSwitch!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.greyBackgroundView = UIImageView(image: #imageLiteral(resourceName: "player-grey-circle-background"))
        self.greyBackgroundView.contentMode = .scaleAspectFit
        self.addSubview(self.greyBackgroundView)
        
        self.redBackgroundView = UIImageView(image: #imageLiteral(resourceName: "player-red-circle-background"))
        self.redBackgroundView.alpha = 0.0
        self.redBackgroundView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.addSubview(self.redBackgroundView)
        
        
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
        self.greyBackgroundView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        self.redBackgroundView.sizeToFit()
        self.redBackgroundView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        self.offradioSwitch.sizeToFit()
        let x = (self.frame.width - self.offradioSwitch.frame.width) * 0.5
        let y = self.offradioLogo.frame.maxY + 12
        self.offradioSwitch.frame = CGRect(x: x, y: y,
                                           width: self.offradioSwitch.frame.width,
                                           height: self.offradioSwitch.frame.height)
        
    }
    
    
}
