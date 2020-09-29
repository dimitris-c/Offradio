//
//  InterfaceFeedbackService.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 29/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import UIKit

public protocol InterfaceFeedbackType {
    func fireFeedback()
}

public class InterfaceFeedbackService: InterfaceFeedbackType {
    private lazy var hapticGenerator: UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: .medium)
    }()
    
    public init() {}

    public func fireFeedback() {
        self.hapticGenerator.impactOccurred()
    }
}
