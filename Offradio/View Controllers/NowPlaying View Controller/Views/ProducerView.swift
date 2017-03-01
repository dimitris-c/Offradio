//
//  ProducerView.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

final class ProducerView: UIView {
 
    fileprivate final var producerImageView: UIImageView!
    fileprivate final var onAirIconView: UIImageView!
    fileprivate final var producerNameLabel: UILabel!
    fileprivate final var producerBodyLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
