import Foundation

protocol SettingsManagerProtocol {
    static var shared: SettingsManager { get }
    var settings: Settings { get set }
}

final class SettingsManager: SettingsManagerProtocol {
    
    static let shared = SettingsManager()
    
    private let key = "Settings"
    private let defaultSettings = Settings(height: .feet,
                                   diameter: .feet,
                                   mass: .lb,
                                   payloadWeight: .lb)
    
    
    private init () {}
    
    var settings: Settings {
        get {
            guard let savedSettings = UserDefaults.standard.object(forKey: key) as? Data,
                  let settings = try? JSONDecoder().decode(Settings.self, from: savedSettings) else {
                return defaultSettings
            }
//            print("load \(settings.height)")
//            print("load \(settings.diameter)")
//            print("load \(settings.mass)")
//            print("load \(settings.payloadWeight)")
            return settings
        } set {
//            print("save \(newValue.height)")
//            print("save \(newValue.diameter)")
//            print("save \(newValue.mass)")
//            print("save \(newValue.payloadWeight)")
            guard let encodedSettings = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(encodedSettings, forKey: key)
        }
    }
}
