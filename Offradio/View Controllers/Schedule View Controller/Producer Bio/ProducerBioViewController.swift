//
//  ProducerBioViewController.swift
//  Offradio
//
//  Created by Dimitris C. on 09/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAnalytics

final class ProducersBioViewController: UIViewController, UIScrollViewDelegate {

    fileprivate var producer: Producer!

    fileprivate var scrollView: UIScrollView!
    fileprivate var scrollViewContainer: UIView!

    fileprivate var producerTopView: UIView!
    fileprivate var producerImageView: UIImageView!
    fileprivate var producerNameLabel: UILabel!
    fileprivate var producerBioLabel: UILabel!

    fileprivate var producerTopViewInitialHeight: CGFloat = 0

    init(with producer: Producer) {
        super.init(nibName: nil, bundle: nil)
        self.producer = producer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightBlack

        self.title = self.producer.name

        self.scrollView = UIScrollView(frame: .zero)
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)

        self.scrollViewContainer = UIView(frame: .zero)
        self.scrollView.addSubview(self.scrollViewContainer)

        self.producerTopView = UIView(frame: .zero)
        self.producerTopView.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1.00)
        self.scrollViewContainer.addSubview(self.producerTopView)

        self.producerImageView = UIImageView(frame: .zero)
        self.producerImageView.clipsToBounds = true
        self.producerTopView.addSubview(self.producerImageView)

        if let imageUrl = self.producer.image {
            self.loadProducerImage(with: imageUrl)
        }

        self.producerNameLabel = UILabel(frame: .zero)
        self.producerNameLabel.textColor = UIColor.white
        self.producerNameLabel.text = self.producer.name.uppercased()
        self.producerNameLabel.textAlignment = .center
        self.producerNameLabel.numberOfLines = 0
        let producerNameLabelfontSize: CGFloat = CGFloat.deviceValue(iPhone: 30, iPad: 40)
        self.producerNameLabel.font = UIFont.leagueGothicItalic(withSize: producerNameLabelfontSize)
        self.scrollViewContainer.addSubview(self.producerNameLabel)

        self.producerBioLabel = UILabel(frame: .zero)
        let fontSize: CGFloat = CGFloat.deviceValue(iPhone: 14, iPad: 20)
        self.producerBioLabel.font = UIFont.letterGothicBold(withSize: fontSize)
        self.producerBioLabel.textColor = UIColor.white
        self.producerBioLabel.numberOfLines = 0
        self.producerBioLabel.lineBreakMode = .byCharWrapping

        let attributedText = NSMutableAttributedString(string: self.producer.bio)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        attributedText.set(paragraph: paragraph)

        self.producerBioLabel.attributedText = attributedText
        self.scrollViewContainer.addSubview(self.producerBioLabel)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.producerImageView?.kf.cancelDownloadTask()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.producerTopViewInitialHeight = self.producerTopView.frame.height
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.scrollView.frame = self.view.bounds
        self.scrollViewContainer.frame = self.scrollView.bounds

        let topViewHeight = self.view.frame.height * CGFloat.deviceValue(iPhone: 0.6, iPad: 0.5)
        self.producerTopView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: topViewHeight)

        self.producerImageView.sizeToFit()
        let imageHeight = topViewHeight - 60
        self.producerImageView.frame.size = CGSize(width: imageHeight, height: imageHeight)
        self.producerImageView.center.x = self.producerTopView.center.x
        self.producerImageView.frame.origin.y = CGFloat.deviceValue(iPhone: 20, iPad: 40)
        self.producerImageView.layer.cornerRadius = self.producerImageView.frame.size.width * 0.5
        self.producerImageView.layer.borderColor = UIColor.white.cgColor
        self.producerImageView.layer.borderWidth = 8
        
        self.producerNameLabel.frame.size.width = self.scrollViewContainer.frame.width
        self.producerNameLabel.sizeToFit()
        self.producerNameLabel.center.x = self.scrollViewContainer.center.x

        self.producerNameLabel.frame.origin.y = self.producerTopView.frame.maxY + 15

        let contentInsetsLabel = UIEdgeInsets.deviceValue(iPhone: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                                                          iPad: UIEdgeInsets(top: 30, left: 80, bottom: 30, right: 80))
        self.producerBioLabel.frame.size.width = self.scrollView.frame.width - contentInsetsLabel.left - contentInsetsLabel.right
        self.producerBioLabel.sizeToFit()

        self.producerBioLabel.center.x = self.scrollView.center.x
        self.producerBioLabel.frame.origin.y = self.producerNameLabel.frame.maxY + contentInsetsLabel.top

        let bottom: CGFloat = self.producerBioLabel.frame.maxY + contentInsetsLabel.bottom

        self.scrollViewContainer.frame.size = CGSize(width: self.scrollView.frame.width, height: bottom)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: bottom)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let y = -scrollView.contentOffset.y
        if y > 0 {
            self.producerTopView.frame.origin.y = scrollView.contentOffset.y
            self.producerTopView.frame.size.height = producerTopViewInitialHeight + y
        }

    }

    private func loadProducerImage(with imageUrl: URL) {
        self.producerImageView.kf.indicatorType = .activity
        self.producerImageView.kf.setImage(with: imageUrl, options: [.transition(.fade(0.35))])
    }

}
