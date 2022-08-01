import Foundation

protocol SettingsViewControllerProtocol: AnyObject {
    init(presenter: SettingsPresenterProtocol)
}

protocol SettingsPresenterProtocol: AnyObject {
    init(settingsManager: SettingsManagerProtocol,
         delegate: MainPresenterDelegate,
         output: SettingsOutputProtocol)
    
    var view: SettingsViewControllerProtocol? { get set }
    var delegate: MainPresenterDelegate { get }
    var output: SettingsOutputProtocol { get }
    
    func saveSettings(_ hightSelectedSegment: Int,
                      _ diameterSelectedSegment: Int,
                      _ massSelectedSegment: Int,
                      _ payloadWeightSelectedSegment: Int)
    
    func getHightIndex() -> Int
    func getDiameterIndex() -> Int
    func getMassIndex() -> Int
    func getPayloadWeightIndex() -> Int
    func backButtonPressed()
}

final class SettingsPresenter: SettingsPresenterProtocol {
  
    weak var view: SettingsViewControllerProtocol?
    var settingsManager: SettingsManagerProtocol
    var delegate: MainPresenterDelegate
    var output: SettingsOutputProtocol
    
    required init(settingsManager: SettingsManagerProtocol,
                  delegate: MainPresenterDelegate,
                  output: SettingsOutputProtocol) {
        self.settingsManager = settingsManager
        self.delegate = delegate
        self.output = output
    }
    
    func getHightIndex() -> Int {
        settingsManager.settings.height == .meters ? 0 : 1
    }
    
    func getDiameterIndex() -> Int {
        settingsManager.settings.diameter == .meters ? 0 : 1
    }
    
    func getMassIndex() -> Int {
        settingsManager.settings.mass == .kg ? 0 : 1
    }
    
    func getPayloadWeightIndex() -> Int {
        settingsManager.settings.payloadWeight == .kg ? 0 : 1
    }
    
    func saveSettings(_ hightSelectedSegment: Int,
                      _ diameterSelectedSegment: Int,
                      _ massSelectedSegment: Int,
                      _ payloadWeightSelectedSegment: Int) {
        
        let settings = Settings(
            height: hightSelectedSegment == 0 ? .meters : .feet,
            diameter: diameterSelectedSegment == 0 ? .meters : .feet,
            mass: massSelectedSegment == 0 ? .kg : .lb,
            payloadWeight: payloadWeightSelectedSegment == 0 ? .kg : .lb)
        
        settingsManager.settings = settings
    }
    
    func backButtonPressed() {
        output.moveBack()
    }
}
