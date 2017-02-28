//
//  SDWebImageManager+Rx.swift
//  Offradio
//
//  Created by Dimitris C. on 28/02/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage

extension Reactive where Base: SDWebImageManager {
    
    func loadImage(url: URL, options: SDWebImageOptions) -> Observable<UIImage?> {
        return Observable.create({ observer -> Disposable in
            let operation = SDWebImageManager.shared().loadImage(with: url,
                                                                 options: options,
                                                                 progress: nil) { (image, data, error, cacheType, success, url) in
                                                                    if let error = error {
                                                                        observer.onError(error)
                                                                    } else {
                                                                        observer.onNext(image)
                                                                    }
                                                                    observer.onCompleted()
                                                                    
            }
            return Disposables.create(with: { operation?.cancel() } )
        })
    }
    
}
