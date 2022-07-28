import UIKit

protocol ModuleBuilderProtocol: AnyObject {
    static func createMainModule() -> UIViewController
    static func createLaunchList(with rocketID: String?, and rocketName: String?) -> UIViewController
    static func createSettingsModule(with delegate: MainPresenterDelegate) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    static func createMainModule() -> UIViewController {
        let networkManager = NetworkManager.shared
        let settingsManager = SettingsManager.shared
        let dataManager = DataManager.shared
        let presenter = MainPresenter(networkManager: networkManager,
                                      settingsManager: settingsManager,
                                      dataManager: dataManager)
        let view = MainViewController(presenter: presenter)
        return view

    }

    static func createLaunchList(with rocketID: String?, and rocketName: String?) -> UIViewController {
        
        let networkManager = NetworkManager.shared
        let dataManager = DataManager.shared
        let presenter = LaunchListPresenter(
            networkManager: networkManager,
            dataManager: dataManager,
            rocketID: rocketID,
            rocketName: rocketName)
        let view = LaunchListViewController(presenter: presenter)
        return view
    }

    static func createSettingsModule(with delegate: MainPresenterDelegate) -> UIViewController {
        
        let settingsManager = SettingsManager.shared
        let presenter = SettingsPresenter(settingsManager: settingsManager, delegate: delegate)
        let view = SettingsViewController(presenter: presenter)
        return view
    }
}
