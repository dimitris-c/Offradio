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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        let accessoryImage = item.accesoryImage()?.withRenderingMode(.alwaysTemplate)
        self.accessoryView = UIImageView(image: accessoryImage)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.accessoryView?.tintColor = highlighted ? .red : .white
            }
        } else {
            self.accessoryView?.tintColor = highlighted ? .red : .white
        }
    }

}
