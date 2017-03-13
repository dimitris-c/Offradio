//
//  CurrentTrackShareView.swift
//  Offradio
//
//  Created by Dimitris C. on 12/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

enum ShareType {
    case facebook
    case twitter
    case email
    
    func buttonImage(isSelected selected: Bool = false) -> String {
        switch self {
        case .facebook:
            return selected ? "facebook-share-button-selected" : "facebook-share-button-normal"
        case .twitter:
            return selected ? "twitter-share-button-selected" : "twitter-share-button-normal"
        case .email:
            return selected ? "email-share-button-selected" : "email-share-button-normal"
        }
    }
}

final class CurrentTrackShareView: UIView {
    
    final fileprivate var closeButton: UIButton!
    
    final fileprivate var backgroundView: UIView!
    
    final fileprivate var facebookButton: UIButton!
    final fileprivate var twitterButton: UIButton!
    final fileprivate var emailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true
        
        self.backgroundView = UIView()
        self.backgroundView.backgroundColor = UIColor.red
        self.backgroundView.alpha = 0.9
        self.addSubview(self.backgroundView)
        
        self.closeButton = UIButton(type: .custom)
        self.closeButton.setBackgroundImage(#imageLiteral(resourceName: "share-track-view-close-button-normal"), for: .normal)
        self.closeButton.setBackgroundImage(#imageLiteral(resourceName: "share-track-view-close-button-selected"), for: .highlighted)
        self.addSubview(self.closeButton)
        
        self.facebookButton = UIButton(type: .custom)
        self.facebookButton.setBackgroundImage(UIImage(named: ShareType.facebook.buttonImage()), for: .normal)
        self.facebookButton.setBackgroundImage(UIImage(named: ShareType.facebook.buttonImage(isSelected: true)), for: .highlighted)
        self.addSubview(self.facebookButton)
        
        self.twitterButton = UIButton(type: .custom)
        self.twitterButton.setBackgroundImage(UIImage(named: ShareType.twitter.buttonImage()), for: .normal)
        self.twitterButton.setBackgroundImage(UIImage(named: ShareType.twitter.buttonImage(isSelected: true)), for: .highlighted)
        self.addSubview(self.twitterButton)
        
        self.emailButton = UIButton(type: .custom)
        self.emailButton.setBackgroundImage(UIImage(named: ShareType.email.buttonImage()), for: .normal)
        self.emailButton.setBackgroundImage(UIImage(named: ShareType.email.buttonImage(isSelected: true)), for: .highlighted)
        self.addSubview(self.emailButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundView.frame = self.bounds
        
        self.closeButton.sizeToFit()
        self.facebookButton.sizeToFit()
        self.twitterButton.sizeToFit()
        self.emailButton.sizeToFit()
        
        self.closeButton.frame.origin.x = self.frame.width - self.closeButton.frame.width - 5
        self.closeButton.frame.origin.y = 5
        
    }
    
    
    
}
