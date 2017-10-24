//
//  PlayerCircleContainerView.swift
//  Offradio
//
//  Created by Dimitris C. on 07/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ToggleSwitch

final class PlayerCircleContainerView: UIView {

    fileprivate let disposeBag = DisposeBag()

    let switched: PublishSubject<Bool> = PublishSubject<Bool>()
    let buffering: Variable<Bool> = Variable<Bool>(false)
    let playing: Variable<Bool> = Variable<Bool>(false)

    @IBOutlet weak var bufferCircle: UIImageView!
    @IBOutlet weak var offradioLogo: UIImageView!

    fileprivate final var greyBackgroundView: UIImageView!
    fileprivate final var redBackgroundView: UIImageView!
    fileprivate final var offradioSwitch: ToggleSwitch!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.greyBackgroundView = UIImageView(image: #imageLiteral(resourceName: "player-grey-circle-background"))
        self.greyBackgroundView.contentMode = .scaleAspectFit
        self.addSubview(self.greyBackgroundView)

        self.redBackgroundView = UIImageView(image: #imageLiteral(resourceName: "player-red-circle-background"))
        self.redBackgroundView.contentMode = .scaleAspectFit
        self.redBackgroundView.alpha = 0.0
        self.redBackgroundView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.addSubview(self.redBackgroundView)

        let images = ToggleSwitchImages(baseOnImage: #imageLiteral(resourceName: "toggle_base_on"),
                                        baseOffImage: #imageLiteral(resourceName: "toggle_base_off"),
                                        thumbOnImage: #imageLiteral(resourceName: "toggle_button_on"),
                                        thumbOffImage: #imageLiteral(resourceName: "toggle_button_off"))
        self.offradioSwitch = ToggleSwitch(with: images)
        self.addSubview(self.offradioSwitch)

        self.offradioSwitch.stateChanged = { [weak self] isOn in
            Log.debug("user action: radio should turn on: \(isOn)")
            self?.switched.onNext(isOn)
        }

        buffering.asObservable()
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (buffering) in
                if buffering {
                    self?.startBuffering()
                } else {
                    self?.stopBuffering()
                }
        }).addDisposableTo(disposeBag)

        playing.asObservable()
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (playing) in
                if playing {
                    self?.setPlaying()
                } else {
                    self?.setStopped()
                }
        }).addDisposableTo(disposeBag)

    }

    final func setupViews() {
        self.bufferCircle.alpha = 0.0
    }

    final func rearrangeViews() {
        self.bringSubview(toFront: offradioLogo)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.greyBackgroundView.sizeToFit()
        self.greyBackgroundView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        self.redBackgroundView.sizeToFit()
        self.redBackgroundView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        let iPadOffset: CGFloat = 20
        self.offradioSwitch.sizeToFit()
        let x = (self.frame.width - self.offradioSwitch.frame.width) * 0.5
        let y = self.offradioLogo.frame.maxY + 12 + (DeviceType.iPad ? iPadOffset : 0)
        self.offradioSwitch.frame = CGRect(x: x, y: y,
                                           width: self.offradioSwitch.frame.width,
                                           height: self.offradioSwitch.frame.height)

    }

    fileprivate final func startBuffering() {

        guard buffering.value else { return }

        bufferCircle.layer.opacity = 1.0
        let fadeIn = AnimationsFactory.fadeIn(withDuration: 0.35)
        let rotate = AnimationsFactory.rotate(withDuration: 2.0, indefinetely: true)

        bufferCircle.layer.add(fadeIn, forKey: "opacity")
        bufferCircle.layer.add(rotate, forKey: "rotate360")

    }

    fileprivate final func stopBuffering() {

        guard bufferCircle != nil && !buffering.value else { return }

        bufferCircle.layer.opacity = 0.0
        let fadeOut = AnimationsFactory.fadeOut(withDuration: 0.35)
        self.bufferCircle.layer.add(fadeOut, forKey: "opacityFadeOut")

        self.bufferCircle.layer.removeAnimation(forKey: "rotate360")

    }

    fileprivate final func setPlaying() {
        guard playing.value else { return }

        self.offradioSwitch.setOn(on: true, animated: true)

        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.redBackgroundView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.redBackgroundView.alpha = 1.0
        }, completion: nil)

    }

    fileprivate final func setStopped() {
        guard !playing.value else { return }

        self.offradioSwitch.setOn(on: false, animated: true)

        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: {
            self.redBackgroundView.alpha = 0.0
        }, completion: nil)

    }

}
