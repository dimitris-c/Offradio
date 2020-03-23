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
import MessageUI
import Kingfisher
import FirebaseAnalytics

class ShareUtility: NSObject, MFMailComposeViewControllerDelegate {

    class func share(on type: ShareType, with nowPlaying: NowPlaying, using viewController: UIViewController) {
        switch type {
        case .facebook:
            self.shareOnFacebook(with: nowPlaying, using: viewController)
        case .twitter:
            self.shareOnTwitter(with: nowPlaying, using: viewController)
        case .email:
            self.shareOnEmail(with: nowPlaying, using: viewController)
        default: break
        }
        let attributes: [String: Any] = ["song": nowPlaying.current.title,
                                         "producer": nowPlaying.show.name,
                                         "share_type": type.rawValue]
        Analytics.logEvent("Sharing song", parameters: attributes)
    }

    class func shareOnFacebook(with nowPlaying: NowPlaying, using viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        print("Sharing on Facebook")
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL(string: "http://www.offradio.gr")!

        ShareDialog(fromViewController: viewController, content: shareContent, delegate: nil).show()
    }

    class func shareOnTwitter(with nowPlaying: NowPlaying, using viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        print("Sharing on Twitter")

        let titleFactory = TwitterTitleFactory()
        let title = titleFactory.title(with: nowPlaying)

        let composer = TWTRComposer()
        composer.setText(title)
        composer.setImage(UIImage(named: "turn-your-radio-off"))
        composer.setURL(URL(string: "http://www.offradio.gr"))

        composer.show(from: viewController) { _ in
        }

    }

    class func shareOnEmail(with nowPlaying: NowPlaying, using viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        print("Sharing on email")

        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = viewController as? MFMailComposeViewControllerDelegate
            mailController.setSubject("I'm listening to Offradio!")
            let messageBody = "I've turned my Radio OFF! <p>Listening to <b> \(nowPlaying.show.name).</b> <br>Currently playing <b> \(nowPlaying.current.title) </b></p> <p> Turn your radio OFF at — http://www.offradio.com/player </p>"
            mailController.setMessageBody(messageBody, isHTML: true)
            viewController.present(mailController, animated: true, completion: nil)
        }
    }

}

struct TwitterTitleFactory {
    private let firstPart: String = "I've turned my Radio OFF!"
    private let hashtag: String = "#nowplaying"
    private let mention: String = "@offradio"

    private let limit: Int = 140

    func title(with nowPlaying: NowPlaying) -> String {
        var fullTitle = "\(firstPart) Listening to \(nowPlaying.show.name) \(hashtag) \(nowPlaying.current.title) \(mention)"
        if fullTitle.count > limit {
            fullTitle = "\(firstPart) Listening to \(nowPlaying.current.title) \(hashtag) \(mention)"
        }
        if fullTitle.count > limit {
            fullTitle = "Listening to \(nowPlaying.current.title) \(hashtag) \(mention)"
        }
        if fullTitle.count > limit {
            fullTitle = "Listening to \(nowPlaying.current.title) \(hashtag) \(mention)"
        }
        return fullTitle
    }
}
