//
//  ProducerView.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage

final class ProducerView: UIView {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate final var container: UIView!
    fileprivate final var producerImageView: UIImageView!
    fileprivate final var onAirIconView: UIImageView!
    fileprivate final var producerNameLabel: UILabel!
    fileprivate final var producerBodyLabel: UILabel!
    
    init(with currentTrack: Driver<Show>) {
        super.init(frame: .zero)
        
        self.container = UIView()
        self.addSubview(self.container)
        
        let sizeWidthHeight: CGFloat = CGFloat.deviceValue(iPhone: 65, iPad: 85)
        self.producerImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: sizeWidthHeight, height: sizeWidthHeight)))
        self.producerImageView.layer.cornerRadius = CGFloat(sizeWidthHeight * 0.5)
        self.producerImageView.layer.masksToBounds = true
        self.producerImageView.layer.borderColor = UIColor.white.cgColor
        self.container.addSubview(self.producerImageView)
        
        self.supplySubviews()
        
        currentTrack.asObservable()
            .map { $0.largePhoto }
            .subscribe(onNext: { [weak self] url in
                if let url = URL(string: url) {
                    self?.producerImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "producer-static-image"))
                }
            }).addDisposableTo(disposeBag)
        
        currentTrack.asObservable()
            .map { $0.name }
            .ifEmpty(default: Show.default.name)
            .bind(to: self.producerNameLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        currentTrack.asObservable()
            .map { $0.body }
            .ifEmpty(default: Show.default.body)
            .bind(to: self.producerBodyLabel.rx.text)
            .addDisposableTo(disposeBag)
        
    }
    
    func supplySubviews() {
        self.onAirIconView = UIImageView(image: #imageLiteral(resourceName: "onair_icon_bg"))
        self.container.addSubview(self.onAirIconView)
        
        self.producerNameLabel = UILabel(frame: .zero)
        self.producerNameLabel.font = UIFont.letterGothicBold(withSize: 15)
        self.producerNameLabel.textColor = UIColor.white
        self.producerNameLabel.textAlignment = .left
        self.producerNameLabel.numberOfLines = 1
        self.container.addSubview(self.producerNameLabel)
        
        self.producerBodyLabel = UILabel(frame: .zero)
        self.producerBodyLabel.font = UIFont.letterGothicBold(withSize: 15)
        self.producerBodyLabel.textColor = UIColor.white
        self.producerBodyLabel.textAlignment = .left
        self.producerBodyLabel.numberOfLines = 3
        self.container.addSubview(self.producerBodyLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let containerHeight: CGFloat = CGFloat.deviceValue(iPhone: 65, iPad: 100)
        let padding: CGFloat = CGFloat.deviceValue(iPhone: 40, iPad: 85)
        self.container.frame.size = CGSize(width: self.frame.width - padding,
                                           height: containerHeight)
        
        self.container.center = CGPoint(x: self.frame.width * 0.5,
                                        y: self.frame.height * 0.5)
        
        self.onAirIconView.frame.origin.x       = self.producerImageView.frame.maxX + 10
        self.producerNameLabel.frame.origin.x   = self.producerImageView.frame.maxX + 10
        self.producerBodyLabel.frame.origin.x   = self.producerImageView.frame.maxX + 10
        
        var verticalArranger = VerticalArranger()
        verticalArranger.add(object: SizeObject(type: .fixed, view: self.onAirIconView))
        verticalArranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 5)))
        verticalArranger.add(object: SizeObject(type: .flexible, view: self.producerNameLabel))
        verticalArranger.add(object: SizeObject(type: .fixed, size: CGSize(width: 0, height: 5)))
        verticalArranger.add(object: SizeObject(type: .flexible, view: self.producerBodyLabel))
        
        verticalArranger.resizeToFit()
        verticalArranger.arrange()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
