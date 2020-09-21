//
//  SettingsToggableTableViewCell.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 19/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsToggableTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    let toggleSwitch = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.tintColor = .lightBlack
        self.backgroundColor = .lightBlack
        self.contentView.backgroundColor = .lightenBlack
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.tintColor = .black
        toggleSwitch.onTintColor = .offRed
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggleSwitch.leadingAnchor, constant: 10),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, value: Bool) {
        self.titleLabel.text = title
        self.toggleSwitch.isOn = value
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}
