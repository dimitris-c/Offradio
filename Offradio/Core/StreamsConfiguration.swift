//
//  StreamsConfiguration.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import RxSwift

protocol PlayerConfigurationProvider {
    var configuration: PlayerConfiguration { get }
}

final class PlayerConfigurationService: PlayerConfigurationProvider {
    private let networkService: OffradioNetworkService
    
    private let disposeBag = DisposeBag()
    var configuration: PlayerConfiguration = .default
    
    init(networkService: OffradioNetworkService) {
        self.networkService = networkService
        
        self.fetchConfiguration()
    }
    
    private func fetchConfiguration() {
        self.networkService.rx.request(.configuration)
            .map(PlayerConfiguration.self, atKeyPath: nil, using: Decoders.defaultJSONDecoder, failsOnEmptyData: false)
            .subscribe { [weak self] config in
                guard let self = self else { return }
                self.configuration = config
            } onError: { _ in
                self.configuration = .default
            }.disposed(by: disposeBag)
    }
}
