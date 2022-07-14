import Foundation

final class SettingsManager {
    
    static let shared = SettingsManager()
    
    static var settings = Settings(height: .feet,
                                   diameter: .feet,
                                   mass: .lb,
                                   payloadWeights: .lb)
    
    private init () {}
}
