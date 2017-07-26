//
//  ContactModels.swift
//  Offradio
//
//  Created by Dimitris C. on 10/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import Foundation

enum ContactItemType {
    case facebook
    case twitter
    case email
    case visit
}

struct ContactItem {
    let title: String
    let type: ContactItemType

    func accesoryImages() -> (normal: UIImage, selected: UIImage) {
        switch type {
        case .facebook:
            return (#imageLiteral(resourceName: "fb_icon"), #imageLiteral(resourceName: "fb_icon_selected"))
        case .twitter:
            return (#imageLiteral(resourceName: "twitter_icon"), #imageLiteral(resourceName: "twitter_icon_selected"))
        case .email:
            return (#imageLiteral(resourceName: "mail_icon"), #imageLiteral(resourceName: "mail_icon_selected"))
        case .visit:
            return (#imageLiteral(resourceName: "web_icon"), #imageLiteral(resourceName: "web_icon_selected"))
        }
    }
}
