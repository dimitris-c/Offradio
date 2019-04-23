//
//  CurrentTrackShareView.swift
//  Offradio
//
//  Created by Dimitris C. on 12/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CurrentTrackShareView: UIView {
    final fileprivate let disposeBag: DisposeBag = DisposeBag()

    final fileprivate var closeButton: UIButton!

    final fileprivate var backgroundView: UIView!

    final fileprivate var shareButtons: [ShareButton] = []
    final fileprivate var facebookButton: ShareButton!
    final fileprivate var twitterButton: ShareButton!
    final fileprivate var emailButton: ShareButton!

    final let shareOn: Variable<ShareType> = Variable<ShareType>(.none)

    var closeButtonTap: ControlEvent<Void> {
        return self.closeButton.rx.tap
    }

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

        self.facebookButton = ShareButton(with: .facebook)
        self.facebookButton.alpha = 0
        self.addSubview(self.facebookButton)

        self.twitterButton = ShareButton(with: .twitter)
        self.twitterButton.alpha = 0
        self.addSubview(self.twitterButton)

        self.emailButton = ShareButton(with: .email)
        self.emailButton.alpha = 0
        self.addSubview(self.emailButton)

        self.shareButtons = [self.facebookButton, self.twitterButton, self.emailButton]

        self.shareButtons.forEach { button in
            button.rx.tap.map { button.shareType }.bind(to: self.shareOn).disposed(by: disposeBag)
        }
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

        self.facebookButton.center.x = self.center.x
        self.twitterButton.center.x = self.center.x
        self.emailButton.center.x = self.center.x

        let gap: CGFloat = 10
        let totalHeight = self.facebookButton.frame.height + self.twitterButton.frame.height + self.emailButton.frame.height + gap * 2

        self.facebookButton.frame.origin.y  = (self.frame.height - totalHeight) * 0.5
        self.twitterButton.frame.origin.y   = self.facebookButton.frame.maxY + gap
        self.emailButton.frame.origin.y   = self.twitterButton.frame.maxY + gap

    }

    func showButtons() {
        for (index, button) in self.shareButtons.enumerated() {
            button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.2,
                           delay: TimeInterval(CGFloat(index) * 0.05),
                           options: .curveEaseInOut,
                           animations: {
                            button.transform = CGAffineTransform.identity
                            button.alpha = 1
            }, completion: nil)
        }
    }

    func hideButtons() {
        self.shareButtons.forEach { $0.alpha = 0 }
    }

}
