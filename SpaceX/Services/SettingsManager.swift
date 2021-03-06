import Foundation

protocol SettingsManagerProtocol {
    static var shared: SettingsManager { get }
    var settings: Settings { get set }
}

final class SettingsManager: SettingsManagerProtocol {
    
    static let shared = SettingsManager()
    
    private let settingsKey = "Settings"
    private let defaultSettings = Settings(height: .feet,
                                   diameter: .feet,
                                   mass: .lb,
                                   payloadWeight: .lb)
    
    private init () {}
    
    var settings: Settings {
        get {
            guard let savedSettings = UserDefaults.standard.object(forKey: settingsKey) as? Data,
                  let settings = try? JSONDecoder().decode(Settings.self, from: savedSettings) else {
                return defaultSettings
            }
            return settings
        } set {

            guard let encodedSettings = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(encodedSettings, forKey: settingsKey)
        }
    }
}
