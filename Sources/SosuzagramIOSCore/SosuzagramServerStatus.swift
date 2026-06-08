import Foundation
import Network
import QuartzCore

public let sosuzagramPingUpdatedNotification = Notification.Name("SosuzagramPingUpdated")

public final class SosuzagramServerStatus {
    public static let shared = SosuzagramServerStatus()
    
    private(set) public var currentPing: Int?
    private(set) public var currentDatacenterId: Int32 = 0
    private(set) public var lastErrorDescription: String?
    private let queue = DispatchQueue(label: "org.sosuzagram.ping", qos: .background)
    private var timer: DispatchSourceTimer?
    
    public func startPinging(datacenterId: Int32) {
        self.queue.async {
            if self.currentDatacenterId == datacenterId, self.timer != nil {
                return
            }
            
            self.stopTimer()
            self.currentDatacenterId = datacenterId
            self.lastErrorDescription = nil
            
            let ip = self.ipAddress(for: datacenterId)
            let timer = DispatchSource.makeTimerSource(queue: self.queue)
            timer.schedule(deadline: .now(), repeating: 5.0, leeway: .seconds(1))
            timer.setEventHandler { [weak self] in
                self?.pingHost(ip: ip)
            }
            self.timer = timer
            timer.resume()
        }
    }
    
    public func stopPinging() {
        self.queue.async {
            self.stopTimer()
            self.currentPing = nil
            self.lastErrorDescription = nil
            self.currentDatacenterId = 0
            self.notifyUpdated()
        }
    }
    
    private func pingHost(ip: String) {
        let startTime = CACurrentMediaTime()
        let host = NWEndpoint.Host(ip)
        let port = NWEndpoint.Port(integerLiteral: 443)
        let connectionQueue = DispatchQueue(label: "org.sosuzagram.ping.connection", qos: .utility)
        
        let connection = NWConnection(host: host, port: port, using: .tcp)
        let semaphore = DispatchSemaphore(value: 0)
        var didFinish = false
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                didFinish = true
                let duration = CACurrentMediaTime() - startTime
                let pingMs = Int(duration * 1000.0)
                self.currentPing = pingMs
                self.lastErrorDescription = nil
                self.notifyUpdated()
                connection.cancel()
                semaphore.signal()
            case let .failed(error):
                didFinish = true
                self.currentPing = nil
                self.lastErrorDescription = error.localizedDescription
                self.notifyUpdated()
                semaphore.signal()
            case .cancelled:
                didFinish = true
                semaphore.signal()
            default:
                break
            }
        }
        
        connection.start(queue: connectionQueue)
        if semaphore.wait(timeout: .now() + 2.0) == .timedOut, !didFinish {
            connection.cancel()
            self.currentPing = nil
            self.lastErrorDescription = "Timeout"
            self.notifyUpdated()
        }
    }
    
    private func ipAddress(for datacenterId: Int32) -> String {
        switch datacenterId {
        case 1:
            return "149.154.175.50"
        case 2:
            return "149.154.167.51"
        case 3:
            return "149.154.175.100"
        case 4:
            return "149.154.167.91"
        case 5:
            return "91.108.56.115"
        default:
            return "91.108.56.115"
        }
    }
    
    private func stopTimer() {
        self.timer?.setEventHandler {}
        self.timer?.cancel()
        self.timer = nil
    }
    
    private func notifyUpdated() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: sosuzagramPingUpdatedNotification, object: nil)
        }
    }
}
