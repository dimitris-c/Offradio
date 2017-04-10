//
//  ShareUtility.swift
//  Offradio
//
//  Created by Dimitris C. on 10/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import FBSDKCoreKit
import FBSDKShareKit
import TwitterKit

class ShareUtility {
    
    class func share(on type: ShareType, with currentTrack: CurrentTrack, using viewController: UIViewController) {
        switch type {
        case .facebook:
            self.shareOnFacebook(with: currentTrack, using: viewController)
        default: break
        }
    }
    
    class func shareOnFacebook(with currentTrack: CurrentTrack, using viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        print("Sharing \(currentTrack) on Facebook")
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentTitle = "I'm listening to \(currentTrack.track) by \(currentTrack.title) at Offradio"
        shareContent.contentURL = URL(string: "http://www.offradio.gr/player")
        shareContent.contentDescription = "Turn your radio OFF too at www.offradio.gr/player or download the Mobile Apps at www.offradio.gr/apps"
        shareContent.ref = "offradio_ios_app"
        if let url = URL(string: currentTrack.image) {
            shareContent.imageURL = url
        }
        
        FBSDKShareDialog.show(from: viewController, with: shareContent, delegate: nil)
    }
    
    class func shareOnTwitter(with currentTrack: CurrentTrack, using viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        print("Sharing \(currentTrack) on Twitter")
        
        let composer = TWTRComposer()
        composer.setText("")
        composer.setURL(URL(string: ""))
        composer.setImage(UIImage(named: ""))
        
        composer.show(from: viewController) { result in
            
        }
    }
    
}
