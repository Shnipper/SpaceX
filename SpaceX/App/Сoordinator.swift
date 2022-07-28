import Foundation
import UIKit

protocol CoordinatorProtocol {
    init(moduleBuilder: ModuleBuilderProtocol,
         navigationController: UINavigationController)
    
    func start()
    func moveToSettings(rocketID: String?, rocketName: String?)
    func moveToLaunchList()
}

class Coordinator: CoordinatorProtocol {
    
    let moduleBuilder: ModuleBuilderProtocol
    let navigationController: UINavigationController?
    
    required init(moduleBuilder: ModuleBuilderProtocol,
                  navigationController: UINavigationController) {
        self.moduleBuilder = moduleBuilder
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func moveToSettings(rocketID: String?, rocketName: String?) {
        
        let vc = moduleBuilder.createLaunchListModule(rocketID: rocketID, rocketName: rocketName)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func moveToLaunchList() {
        
    }
}
