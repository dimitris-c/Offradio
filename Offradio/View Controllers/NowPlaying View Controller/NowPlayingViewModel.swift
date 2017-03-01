//
//  NowPlayingViewModel.swift
//  Offradio
//
//  Created by Dimitris C. on 01/03/2017.
//  Copyright © 2017 decimal. All rights reserved.
//

import RxSwift
import RxCocoa

final class NowPlayingViewModel {
    
    fileprivate var radioMetadata: OffradioMetadata!
    
    let show: Variable<Show> = Variable<Show>(.empty)
    
    init(with radioMetadata: OffradioMetadata) {
        self.radioMetadata = radioMetadata
    }
    
}
