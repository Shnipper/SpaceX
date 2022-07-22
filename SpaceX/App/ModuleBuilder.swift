import UIKit

protocol ModuleBuilderProtocol: AnyObject {
    static func createMainModule() -> UIViewController
    static func createLaunchListModule() -> UIViewController
    static func createSettingsModule() -> UIViewController
}

//class ModuleBuilder: ModuleBuilderProtocol {
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
//
//    func createLaunchListModule() -> UIViewController {
//        let view = LaunchListViewController()
//        let networkManager = NetworkManager()
//        let dataManager = DataManager()
//        let presenter = LaunchListPresenter()
//        view.presenter = presenter
//        return view
//    }

//    func createSettingsModule() -> UIViewController {
//        let view = SettingsViewController()
//        let settingsManager = SettingsManager.shared
//        let presenter = SettingsPresenter()
//        view.presenter = presenter
//        return view
//    }
//}
