//
//  ShareButton.swift
//  Offradio
//
//  Created by Dimitris C. on 10/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

class ShareButton: UIButton {
    var shareType: ShareType!

    init(with shareType: ShareType) {
        super.init(frame: .zero)
        self.shareType = shareType

        self.setBackgroundImage(UIImage(named: shareType.buttonImage()), for: .normal)
        self.setBackgroundImage(UIImage(named: shareType.buttonImage(isSelected: true)), for: .highlighted)
        self.setBackgroundImage(UIImage(named: shareType.buttonImage(isSelected: true)), for: .selected)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
