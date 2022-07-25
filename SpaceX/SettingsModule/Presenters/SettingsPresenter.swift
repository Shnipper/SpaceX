import Foundation

protocol SettingsViewControllerProtocol: AnyObject {
    init(presenter: SettingsPresenterProtocol)
}

protocol SettingsPresenterProtocol: AnyObject {
    init(settingsManager: SettingsManagerProtocol)
    
    var view: SettingsViewControllerProtocol? { get set }
}

class SettingsPresenter: SettingsPresenterProtocol {
  
    weak var view: SettingsViewControllerProtocol?
    
    let settingsManager: SettingsManagerProtocol
    
    required init(settingsManager: SettingsManagerProtocol) {
        self.settingsManager = settingsManager
    }
}
