import UIKit

protocol ModuleBuilderProtocol: AnyObject {
//    static func createMainModule() -> UIViewController
    static func createLaunchList(with rocketID: String, and rocketName: String) -> UIViewController
//    static func createSettingsModule() -> UIViewController
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
        let view = LaunchListViewController()
        let networkManager = NetworkManager()
        let dataManager = DataManager()
        let presenter = LaunchListPresenter(
            view: view,
            networkManager: networkManager,
            dataManager: dataManager,
            rocketID: rocketID,
            rocketName: rocketName)
        
        view.presenter = presenter
        print("create")
        return view
    }

//    func createSettingsModule() -> UIViewController {
//        let view = SettingsViewController()
//        let settingsManager = SettingsManager.shared
//        let presenter = SettingsPresenter()
//        view.presenter = presenter
//        return view
//    }
}
