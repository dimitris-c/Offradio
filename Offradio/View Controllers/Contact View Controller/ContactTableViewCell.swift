//
//  ContactTableViewCell.swift
//  Offradio
//
//  Created by Dimitris C. on 10/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

final class ContactTableViewCell: UITableViewCell, ConfigurableCell {

    final private(set) var item: ContactItem!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.lightenBlack
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.seperatorColor
        self.selectedBackgroundView = selectedView

        self.textLabel?.font = UIFont.letterGothicBold(withSize: CGFloat.deviceValue(iPhone: 16, iPad: 20))
        self.textLabel?.textColor = UIColor.white

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: ContactItem) {
        self.item = item

        self.textLabel?.text = item.title
        let accessoryImage = item.accesoryImages()
        self.accessoryView = UIImageView(image: accessoryImage.normal, highlightedImage: accessoryImage.selected)
    }

}
