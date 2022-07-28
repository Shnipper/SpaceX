import Foundation

protocol DataManagerProtocol {
    
    var rockets: [Rocket] { get set }
    var launches: [Launch] { get set }
    var images: [String? : Data] { get set }
    static var shared: DataManager { get }
    
    func getCurrentLaunches(with rocketId: String) -> [Launch]
}

final class DataManager: DataManagerProtocol {
    
    static let shared = DataManager()
    
    var rockets: [Rocket] = []
    var launches: [Launch] = []
    var images: [String? : Data] = [:]
    
    func getCurrentLaunches(with rocketId: String) -> [Launch] {
        var currentLaunches: [Launch] = []
        launches.forEach {
            if $0.rocket == rocketId {
                if $0.success != nil {
                    currentLaunches.append($0)
                }
            }
        }
        return currentLaunches
    }
    
    private init() {}
}
