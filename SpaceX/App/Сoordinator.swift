import Foundation
import UIKit

protocol CoordinatorProtocol {
    init(moduleBuilder: ModuleBuilderProtocol)
    
    func start(_ window: UIWindow)
}

final class Coordinator: CoordinatorProtocol {
    
    private let moduleBuilder: ModuleBuilderProtocol
    private var navigationController: UINavigationController?
    
    required init(moduleBuilder: ModuleBuilderProtocol) {
        self.moduleBuilder = moduleBuilder
    }
    
    func start(_ window: UIWindow) {
        let mainViewController = moduleBuilder.createMainModule(output: self)
        navigationController = UINavigationController(rootViewController: mainViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension Coordinator: MainOutputProtocol {
    
    func moveToSettings(_ mainPresenterDelegate: MainPresenterDelegate) {
        guard let navigationController = navigationController else { return }
        let settingsViewController = moduleBuilder.createSettingsModule(
            with: mainPresenterDelegate,
            output: self)
        navigationController.present(settingsViewController, animated: true)
    }
    
    func moveToLaunchList(rocketID: String?, rocketName: String?) {
        guard let navigationController = navigationController else { return }
        let vc = moduleBuilder.createLaunchListModule(rocketID: rocketID,
                                                      rocketName: rocketName)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension Coordinator: SettingsOutputProtocol {
    func moveBack() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true)
    }
}
