import Foundation

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
