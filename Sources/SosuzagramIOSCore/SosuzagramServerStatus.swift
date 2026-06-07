import Foundation
import Network
import QuartzCore

public final class SosuzagramServerStatus {
    public static let shared = SosuzagramServerStatus()
    
    private(set) public var currentPing: Int?
    private var isPinging = false
    private let queue = DispatchQueue(label: "org.sosuzagram.ping", qos: .background)
    private var timer: Timer?
    
    public func startPinging(datacenterId: Int32) {
        guard !self.isPinging else { return }
        self.isPinging = true
        
        let ip: String
        switch datacenterId {
        case 1: ip = "149.154.175.50"
        case 2: ip = "149.154.167.51"
        case 3: ip = "149.154.175.100"
        case 4: ip = "149.154.167.91"
        case 5: ip = "91.108.56.115"
        default: ip = "91.108.56.115"
        }
        
        self.queue.async { [weak self] in
            self?.pingHost(ip: ip)
            
            // Run a simple timer loop in background
            while true {
                Thread.sleep(forTimeInterval: 5.0) // Ping every 5 seconds
                self?.pingHost(ip: ip)
            }
        }
    }
    
    private func pingHost(ip: String) {
        let startTime = CACurrentMediaTime()
        let host = NWEndpoint.Host(ip)
        let port = NWEndpoint.Port(integerLiteral: 443)
        
        let connection = NWConnection(host: host, port: port, using: .tcp)
        let semaphore = DispatchSemaphore(value: 0)
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                let duration = CACurrentMediaTime() - startTime
                let pingMs = Int(duration * 1000.0)
                DispatchQueue.main.async {
                    self.currentPing = pingMs
                    NotificationCenter.default.post(name: NSNotification.Name("SosuzagramPingUpdated"), object: nil)
                }
                connection.cancel()
                semaphore.signal()
            case .failed, .cancelled:
                semaphore.signal()
            default:
                break
            }
        }
        
        connection.start(queue: self.queue)
        _ = semaphore.wait(timeout: .now() + 2.0) // 2 seconds timeout
    }
}
