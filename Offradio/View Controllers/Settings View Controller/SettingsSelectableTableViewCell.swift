//
//  SettingsToggableTableViewCell.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 19/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import UIKit

class SettingsSelectableTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .lightBlack
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        self.accessoryView = UIImageView(image: UIImage(named: "checkmark-icon"))
        self.accessoryView?.tintColor = .offRed
        
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.backgroundColor = selected ? .lightBlack : .lightenBlack
    }
    
    func configure(with title: String, value: Bool, enabled: Bool) {
        self.titleLabel.text = title
        self.titleLabel.textColor = enabled ? .white : UIColor(white: 1.0, alpha: 0.4)
        self.accessoryView?.isHidden = !(value && enabled)
        // a bit hacky...
        self.selectionStyle = enabled ? .gray : .none
    }

}
