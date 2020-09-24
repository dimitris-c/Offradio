//
//  Dependencies.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 24/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Moya
import Network

typealias OffradioNetworkService = MoyaProvider<OffradioNetworkAPI>

protocol CoreDependencies {
    var userSettings: UserSettings { get }
    var networkService: OffradioNetworkService { get }
    var metadata: RadioMetadata { get }
    var netStatusService: NetStatusProvider { get }
    var offradio: Offradio { get }
    var watchCommunication: OffradioWatchCommunication { get }
}

final class CoreDependenciesService: CoreDependencies {
    let userSettings: UserSettings
    let metadata: RadioMetadata
    let netStatusService: NetStatusProvider
    let offradio: Offradio
    let watchCommunication: OffradioWatchCommunication
    let networkService: OffradioNetworkService
    
    init() {
        self.userSettings = UserSettingsService()
        self.networkService = MoyaProvider<OffradioNetworkAPI>()
        self.metadata = OffradioMetadata(networkService: networkService)
        self.netStatusService = NetStatusService(network: NWPathMonitor())
        self.offradio = Offradio(userSettings: userSettings, metadata: metadata, netStatusService: netStatusService)
        self.watchCommunication = OffradioWatchCommunication()
    }
}
