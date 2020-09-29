//
//  ProducerView.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import Kingfisher

final class ProducerView: UIView {
    fileprivate let disposeBag = DisposeBag()

    fileprivate final var container: UIView!
    fileprivate final var producerImageView: UIImageView!
    fileprivate final var onAirIconView: UIImageView!
    fileprivate final var producerNameLabel: UILabel!
    fileprivate final var producerBodyLabel: UILabel!

    init(with show: Driver<ProducerShow>) {
        super.init(frame: .zero)

        self.container = UIView()
        self.addSubview(self.container)

        self.producerImageView = UIImageView()
        self.producerImageView.layer.masksToBounds = true
        self.producerImageView.layer.borderColor = UIColor.white.cgColor
        self.container.addSubview(self.producerImageView)

        self.supplySubviews()

        show.asObservable()
            .map { $0.producerImage }
            .subscribe(onNext: { [weak self] url in
                if let url = URL(string: url) {
                    self?.producerImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "producer-static-image"))
                }
            }).disposed(by: disposeBag)

        show.asObservable()
            .map { $0.producerName }
            .ifEmpty(default: ProducerShow.default.producerName)
            .bind(to: self.producerNameLabel.rx.text)
            .disposed(by: disposeBag)

        show.asObservable()
            .map { $0.showTitle }
            .ifEmpty(default: ProducerShow.default.showTitle)
            .bind(to: self.producerBodyLabel.rx.text)
            .disposed(by: disposeBag)

    }

    func supplySubviews() {
        self.onAirIconView = UIImageView(image: #imageLiteral(resourceName: "onair_icon_bg"))
        self.container.addSubview(self.onAirIconView)

        let labelSize: CGFloat = CGFloat.deviceValue(iPhone: 15, iPad: 20)

        self.producerNameLabel = UILabel(frame: .zero)
        self.producerNameLabel.font = UIFont.robotoRegular(withSize: labelSize)
        self.producerNameLabel.textColor = UIColor.white
        self.producerNameLabel.textAlignment = .left
        self.producerNameLabel.numberOfLines = 2
        self.container.addSubview(self.producerNameLabel)

        self.producerBodyLabel = UILabel(frame: .zero)
        self.producerBodyLabel.font = UIFont.robotoRegular(withSize: labelSize)
        self.producerBodyLabel.textColor = UIColor.white
        self.producerBodyLabel.textAlignment = .left
        self.producerBodyLabel.numberOfLines = 4
        self.container.addSubview(self.producerBodyLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if DeviceType.iPad {
            self.layoutForLargeDevices()
        } else {
            self.layoutForSmallDevices()
        }

    }
    /// iPhone
    fileprivate func layoutForSmallDevices() {
        let containerHeight: CGFloat = 120
        let padding: CGFloat = 40
        self.container.frame.size = CGSize(width: self.frame.width - padding,
                                           height: containerHeight)

        self.container.center = CGPoint(x: self.frame.width * 0.5,
                                        y: self.frame.height * 0.5)

        self.onAirIconView.frame.origin.x       = self.producerImageView.frame.maxX + 10
        self.producerNameLabel.frame.origin.x   = self.producerImageView.frame.maxX + 10
        self.producerBodyLabel.frame.origin.x   = self.producerImageView.frame.maxX + 10
        
        self.producerImageView.frame.size = CGSize(width: 80, height: 80)
        self.producerImageView.layer.cornerRadius = CGFloat(self.producerImageView.bounds.height * 0.5)

        var verticalArranger = VerticalArranger()
        verticalArranger.add(object: SizeObject(type: .fixed, view: self.onAirIconView))
        verticalArranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 5)))
        verticalArranger.add(object: SizeObject(type: .flexible, view: self.producerNameLabel))
        verticalArranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 5)))
        let producerBodyObject = SizeObject(type: .flexible, view: self.producerBodyLabel)
        producerBodyObject.setAttached(width: self.container.frame.width - self.producerBodyLabel.frame.origin.x)
        verticalArranger.add(object: producerBodyObject)
        
        verticalArranger.resizeToFit()
        verticalArranger.arrange()
    }

    /// iPad
    fileprivate func layoutForLargeDevices() {

        let width = self.frame.width

        self.producerNameLabel.frame.size.width = width
        self.producerBodyLabel.frame.size.width = width

        self.producerNameLabel.sizeToFit()
        self.producerBodyLabel.sizeToFit()

        let center = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)

        self.producerImageView.center = center
        self.producerNameLabel.center = center
        self.producerBodyLabel.center = center
        self.onAirIconView.center     = center

        var verticalArranger = VerticalArranger()
        verticalArranger.add(object: SizeObject(type: .fixed, view: self.producerImageView))
        verticalArranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 10)))
        verticalArranger.add(object: SizeObject(type: .fixed, view: self.onAirIconView))
        verticalArranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 10)))
        verticalArranger.add(object: SizeObject(type: .flexible, view: self.producerNameLabel))
        verticalArranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 10)))
        verticalArranger.add(object: SizeObject(type: .flexible, view: self.producerBodyLabel))

        verticalArranger.resizeToFit()
        let height = verticalArranger.arrange()

        self.container.frame.size = CGSize(width: width, height: height)
        self.container.center = center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
