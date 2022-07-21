import Foundation

protocol DataManagerProtocol {
    
    static var rockets: [Rocket] { get set }
    static var launches: [Launch] { get set }
    static var images: [String? : Data] { get set }
    
    static func getCurrentLaunches(with rocketId: String) -> [Launch]
}

final class DataManager: DataManagerProtocol {
    
    static var rockets: [Rocket] = []
    static var launches: [Launch] = []
    static var images: [String? : Data] = [:]
    
    static func getCurrentLaunches(with rocketId: String) -> [Launch] {
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
}
