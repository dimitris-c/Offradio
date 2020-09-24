//
//  NetStatusService.swift
//  Offradio
//
//  Created by Dimitrios Chatzieleftheriou on 18/09/2020.
//  Copyright © 2020 decimal. All rights reserved.
//

import Foundation
import Network

enum NetConnectionType: Equatable {
    case cellular(connected: Bool)
    case wifi(connected: Bool)
    case undetermined
}

protocol NetStatusProvider {
    var isConnected: Bool { get }
    var connectionType: NetConnectionType { get }
    
    func start(connectionChange: @escaping (NetConnectionType) -> Void)
    func stop()
}

final class NetStatusService: NetStatusProvider {
    
    var isConnected: Bool {
        network.currentPath.status == .satisfied
    }
    
    var connectionType: NetConnectionType {
        network.currentPath.toNetConnectionType()
    }
    
    private var currentConnectionType: NetConnectionType = .undetermined
    
    private let network: NWPathMonitor
    
    private let monitorQueue: DispatchQueue
    
    init(network: NWPathMonitor) {
        self.network = network
        self.monitorQueue = DispatchQueue(label: "net.path.queue", qos: .background)
    }
    
    deinit {
        network.cancel()
    }
    
    /// Starts the monitoring of connection changes
    ///
    /// - parameter connectionChange: A callback block to listen to changes of the network type, this skips duplicates.
    /// - Note:  The callback will be executed on the main thread.
    func start(connectionChange: @escaping (NetConnectionType) -> Void) {
        network.start(queue: monitorQueue)
        network.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let connecionType = path.toNetConnectionType()
            if self.currentConnectionType != connecionType {
                DispatchQueue.main.async {
                    connectionChange(self.connectionType)
                }
                self.currentConnectionType = self.connectionType
            }
        }
    }
    
    func stop() {
        network.cancel()
        network.pathUpdateHandler = nil
    }
    
}

extension NWPath {
    func toNetConnectionType() -> NetConnectionType {
        let isCellular = self.usesInterfaceType(.cellular)
        let isWifi = self.usesInterfaceType(.wifi)
        let isConnected = self.status == .satisfied
        
        if isCellular {
            return .cellular(connected: isConnected)
        } else if isWifi {
            return .wifi(connected: isConnected)
        }
        
        return .undetermined
    }
}
