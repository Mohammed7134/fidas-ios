//
//  NetworkMonitor.swift
//  Clinical Pharmacist with PHP
//
//  Created by Mohammed Almutawa on 4/29/21.
//

import Foundation
import Network
class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published var isConnected = true
    init() {
        monitor.pathUpdateHandler = { [weak self]  path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}
