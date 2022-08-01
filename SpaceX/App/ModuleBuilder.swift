import UIKit

protocol ModuleBuilderProtocol: AnyObject {
    func createMainModule(output: MainOutputProtocol) -> UIViewController
    func createLaunchListModule(rocketID: String?, rocketName: String?) -> UIViewController
    func createSettingsModule(with delegate: MainPresenterDelegate,
                              output: SettingsOutputProtocol) -> UIViewController
}

final class ModuleBuilder: ModuleBuilderProtocol {
    
    func createMainModule(output: MainOutputProtocol)  -> UIViewController {
        let networkManager = NetworkManager.shared
        let settingsManager = SettingsManager.shared
        let dataManager = DataManager.shared
        let presenter = MainPresenter(networkManager: networkManager,
                                      settingsManager: settingsManager,
                                      dataManager: dataManager,
                                      output: output)
        let view = MainViewController(presenter: presenter)
        return view

    }

    func createLaunchListModule(rocketID: String?, rocketName: String?) -> UIViewController {
        
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

    func createSettingsModule(with delegate: MainPresenterDelegate,
                              output: SettingsOutputProtocol) -> UIViewController {
        
        let settingsManager = SettingsManager.shared
        let presenter = SettingsPresenter(settingsManager: settingsManager,
                                          delegate: delegate,
                                          output: output)
        let view = SettingsViewController(presenter: presenter)
        return view
    }
}
