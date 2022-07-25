import UIKit

protocol ModuleBuilderProtocol: AnyObject {
//    static func createMainModule() -> UIViewController
    static func createLaunchList(with rocketID: String, and rocketName: String) -> UIViewController
    static func createSettingsModule() -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
//    func createMainModule() -> UIViewController {
//        let view = MainViewController()
//        let networkManager = NetworkManager()
//        let settingsManager = SettingsManager.shared
//        let dataManager = DataManager()
//        let presenter = MainPresenter(view: view, networkManager: networkManager, settingsManager: settingsManager, dataManager: dataManager)
//        view.presenter = presenter
//        return view
//
//    }

    static func createLaunchList(with rocketID: String, and rocketName: String) -> UIViewController {
        
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

    static func createSettingsModule() -> UIViewController {
        
        let settingsManager = SettingsManager.shared
        let presenter = SettingsPresenter(settingsManager: settingsManager)
        let view = SettingsViewController(presenter: presenter)
        
        return view
    }
}
