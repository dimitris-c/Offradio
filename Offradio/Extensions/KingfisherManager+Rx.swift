//
//  SDWebImageManager+Rx.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import Kingfisher

extension KingfisherManager: ReactiveCompatible { }

extension Reactive where Base: KingfisherManager {

    func loadImage(url: URL, options: KingfisherOptionsInfo) -> Observable<UIImage?> {
        return Observable.create({ observer -> Disposable in
            let operation = self.base.retrieveImage(with: url, options: options, progressBlock: nil, completionHandler: { (image, error, _, _) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(image)
                    observer.onCompleted()
                }
            })
            return Disposables.create(with: {
                operation.cancel()
            })
        })
    }

}
