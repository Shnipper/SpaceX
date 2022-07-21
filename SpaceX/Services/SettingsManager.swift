import Foundation

final class SettingsManager {
    
    static let shared = SettingsManager()
    
    private let key = "Settings"
    private let defaultSettings = Settings(height: .feet,
                                   diameter: .feet,
                                   mass: .lb,
                                   payloadWeights: .lb)
    
    
    private init () {}
    
    func save(settings: Settings) {
        guard let encodedSettings = try? JSONEncoder().encode(settings) else { return }
        UserDefaults.standard.set(encodedSettings, forKey: key)
        print("save")
    }
    
    func getSettings() -> Settings {
        guard let savedSettings = UserDefaults.standard.object(forKey: key) as? Data,
              let settings = try? JSONDecoder().decode(Settings.self, from: savedSettings) else {
            return defaultSettings
        }
        print("load")
        return settings
    }
    
//    var settings: Settings {
//        get {
//            guard let savedSettings = UserDefaults.standard.object(forKey: key) as? Data,
//                  let settings = try? JSONDecoder().decode(Settings.self, from: savedSettings) else {
//                return defaultSettings
//            }
//            return settings
//        } set {
//            guard let encodedSettings = try? JSONEncoder().encode(newValue) else { return }
//            UserDefaults.standard.set(encodedSettings, forKey: key)
//        }
//    }
}
