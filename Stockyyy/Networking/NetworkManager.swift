import Foundation
import Network

final class NetworkMonitor {

    static let shared = NetworkMonitor()
    private let networkMonitor: NWPathMonitor

    var connectionDidChange: ((Bool) -> Void)?

    private(set) var isConnected = false {
        didSet { connectionDidChange?(isConnected) }
    }

    private let networkQueue = DispatchQueue(label: "NetworkMonitor")

    // MARK: - Initialization

    private init() {
        networkMonitor = NWPathMonitor()
    }

    // MARK: - Methods

    // this is called on the receiving VC
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

    // This needs to be called in the receiving VC's deinit method
    func stopMonitoring() {
        networkMonitor.cancel()
    }
}
