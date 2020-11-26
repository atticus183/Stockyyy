import Foundation
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    let networkMonitor: NWPathMonitor
    
    var connectionDidChange: ((Bool) -> Void)?
    
    private(set) var isConnected = false {
        didSet { connectionDidChange?(isConnected) }
    }
    
    let networkQueue = DispatchQueue(label: "NetworkMonitor")
    
    private init() {
        networkMonitor = NWPathMonitor()
    }
    
    func startMonitor() {
        networkMonitor.start(queue: networkQueue)
        networkMonitor.pathUpdateHandler = { [weak self] path in
            switch path.status {
            case .satisfied:
                self?.isConnected = true
            case .unsatisfied:
                self?.isConnected = false
            case .requiresConnection:
                self?.isConnected = false
            @unknown default:
                self?.isConnected = false
            }
        }
    }
    
    func stopMonitoring() {
        networkMonitor.cancel()
    }
    
}
