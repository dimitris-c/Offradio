//
//  ContactModels.swift
//  Offradio
//
//  Created by Dimitris C. on 10/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit

enum ContactItemType: CaseIterable {
    case facebook
    case twitter
    case email
    case visit
    
    var title: String {
        switch self {
        case .facebook: return "Offradio on Facebook"
        case .twitter: return "Offradio on Twitter"
        case .email: return "Email Offradio"
        case .visit: return "Visit Offradio.gr"
        }
    }
}

struct ContactItem {
    let title: String
    let type: ContactItemType

    func accesoryImage() -> UIImage? {
        switch type {
        case .facebook:
            return UIImage(named: "facebook-icon")
        case .twitter:
            return UIImage(named: "twitter_icon")
        case .email:
            return UIImage(named: "email-icon")
        case .visit:
            return UIImage(named: "website")
        }
    }
}
