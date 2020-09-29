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
    var configurationService: PlayerConfigurationProvider { get }
    var userSettings: UserSettings { get }
    var networkService: OffradioNetworkService { get }
    var metadata: RadioMetadata { get }
    var netStatusService: NetStatusProvider { get }
    var offradio: Offradio { get }
    var watchCommunication: OffradioWatchCommunication { get }
    var interfaceFeedback: InterfaceFeedbackType { get }
}

final class CoreDependenciesService: CoreDependencies {
    let configurationService: PlayerConfigurationProvider
    let userSettings: UserSettings
    let metadata: RadioMetadata
    let netStatusService: NetStatusProvider
    let offradio: Offradio
    let watchCommunication: OffradioWatchCommunication
    let networkService: OffradioNetworkService
    let interfaceFeedback: InterfaceFeedbackType
    
    init() {
        self.userSettings = UserSettingsService()
        self.networkService = MoyaProvider<OffradioNetworkAPI>()
        self.configurationService = PlayerConfigurationService(networkService: networkService)
        self.metadata = OffradioMetadata(networkService: networkService)
        self.netStatusService = NetStatusService(network: NWPathMonitor())
        self.offradio = Offradio(userSettings: userSettings,
                                 metadata: metadata,
                                 netStatusService: netStatusService,
                                 playerConfigurationService: configurationService)
        self.watchCommunication = OffradioWatchCommunication()
        self.interfaceFeedback = InterfaceFeedbackService()
    }
}
