//
//  ShareType.swift
//  Offradio
//
//  Created by Dimitris C. on 10/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

enum ShareType {
    case facebook
    case twitter
    case email
    case none
    
    func buttonImage(isSelected selected: Bool = false) -> String {
        switch self {
        case .facebook:
            return selected ? "facebook-share-button-selected" : "facebook-share-button-normal"
        case .twitter:
            return selected ? "twitter-share-button-selected" : "twitter-share-button-normal"
        case .email:
            return selected ? "email-share-button-selected" : "email-share-button-normal"
        default:
            return ""
        }
    }
    
}
