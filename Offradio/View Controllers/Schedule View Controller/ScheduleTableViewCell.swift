//
//  ScheduleTableViewCell.swift
//  Offradio
//
//  Created by Dimitris C. on 08/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.00)
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
        self.selectedBackgroundView = selectedView
        
        self.textLabel?.font = UIFont.letterGothicBold(withSize: 15)
        self.textLabel?.textColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00)
        
        self.detailTextLabel?.font = UIFont.letterGothicBold(withSize: 15)
        self.detailTextLabel?.textColor = UIColor.white
        
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
