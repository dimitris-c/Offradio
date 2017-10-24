//
//  DebugViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 17/10/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyBeaver

class DebugViewController: UIViewController {

    let textView: UITextView = UITextView()
    var file: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Debug"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeViewController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Email", style: .done, target: self, action: #selector(sendEmail))

        let deviceModel = "Device: \(UIDevice.current.model)"
        let systemNameVersion = "\(UIDevice.current.systemName): \(UIDevice.current.systemVersion)"
        let appVersionBuild = "Offradio v\(Bundle.main.versionNumber ?? "")(\(Bundle.main.buildNumber ?? ""))"

        var text: String = "\(deviceModel)\n\(systemNameVersion)\n\(appVersionBuild)\n\n"

        if let fileDestination = Log.destinations.filter({ $0 is FileDestination }).first as? FileDestination {
            if let fileUrl = fileDestination.logFileURL {
                self.file = fileUrl
                do {
                    let logs = try String(contentsOf: fileUrl)
                    text.append(logs)
                } catch { }
            }
        }

        self.textView.isEditable = false
        self.textView.text = text
        self.view.addSubview(textView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.textView.frame = self.view.bounds
    }

    @objc private func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else { return }
        if let file = file, let data = try? Data(contentsOf: file) {
            let email = MFMailComposeViewController()
            email.setSubject("Offradio debugging")
            email.setToRecipients(["dimmdesign@gmail.com"])
            email.setMessageBody("Attached log filed", isHTML: false)
            email.addAttachmentData(data, mimeType: "text/plain", fileName: "offradio.log")
            email.mailComposeDelegate = self
            self.navigationController?.present(email, animated: true, completion: nil)
        }
    }

}

extension DebugViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
