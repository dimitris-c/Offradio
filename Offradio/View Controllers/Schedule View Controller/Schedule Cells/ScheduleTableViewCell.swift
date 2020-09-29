//
//  ScheduleTableViewCell.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell, ConfigurableCell {

    final private(set) var item: ScheduleItem!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.lightenBlack

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.seperatorColor
        self.selectedBackgroundView = selectedView

        let fontSize: CGFloat = CGFloat.deviceValue(iPhone: 15, iPad: 22)
        self.textLabel?.font = UIFont.robotoRegular(withSize: fontSize)
        self.textLabel?.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)

        self.detailTextLabel?.font = UIFont.robotoRegular(withSize: fontSize)
        self.detailTextLabel?.textColor = UIColor.white

    }

    func configure(with item: ScheduleItem) {
        self.item = item

        self.textLabel?.text = item.timeTitle
        self.detailTextLabel?.text = item.title.uppercased()

        self.accessoryView = nil
        if item.hasBio {
            self.accessoryView = UIImageView(image: #imageLiteral(resourceName: "disclosure-icon"))
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let detail = detailTextLabel, let label = textLabel {
            detail.frame.origin.y = label.frame.maxY + 5
        }

        if let backgroundView = selectedBackgroundView {
            backgroundView.frame = self.bounds
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not worth it")
    }

}
