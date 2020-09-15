//
//  TrackShareViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 09/04/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa

final class TrackShareViewModel {

    final fileprivate let disposeBag = DisposeBag()

    let shareOn: BehaviorRelay<ShareType> = BehaviorRelay<ShareType>(value: .none)

    init(with currentTrack: Driver<CurrentTrack_v2>) {

        shareOn.asObservable().subscribe(onNext: { shareType in
            print("\(shareType)")
        }).disposed(by: disposeBag)

    }

    final fileprivate func share(with type: ShareType) {
        switch type {
        case .facebook:
        break
        case .twitter:
        break
        case .email:
        break
        default:
        break
        }
    }

    final fileprivate func shareOnFacebook() {

    }

    final fileprivate func shareOnTwitter() {

    }

    final fileprivate func shareOnEmail() {

    }
}
