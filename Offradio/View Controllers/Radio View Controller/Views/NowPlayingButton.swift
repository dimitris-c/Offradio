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

    override var isHighlighted: Bool {
        didSet {
            self.backgroundImageView.isHighlighted = isHighlighted
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "nowplaying-button"),
                                               highlightedImage: #imageLiteral(resourceName: "nowplaying-button-selected"))
        self.backgroundImageView.sizeToFit()
        self.addSubview(self.backgroundImageView)

        let scrollLabelOffset: CGFloat = CGFloat.deviceValue(iPhone: 70, iPad: 100)
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

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.backgroundImageView.bounds.size
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundImageView.sizeToFit()

        self.scrollLabel.sizeToFit()
        let paddingLeft = CGFloat.deviceValue(iPhone: 40, iPad: 55)
        self.scrollLabel.frame.origin = CGPoint(x: paddingLeft, y: 0)

    }
    
    func startScrolling() {
        self.scrollLabel.refreshLabels()
    }

}

extension Reactive where Base: NowPlayingButton {
    var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
    
    var title: Binder<String?> {
        return base.scrollLabel.rx.title
    }
}

extension Reactive where Base: CBAutoScrollLabel {
    var title: Binder<String?> {
        return Binder(base) { view, title in
            view.setText(title, refreshLabels: true)
        }
    }
}
