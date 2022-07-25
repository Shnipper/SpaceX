import Foundation

protocol LaunchListViewControllerProtocol: AnyObject {
    func updateUI()
}

protocol LaunchPresenterProtocol: AnyObject {
    init(view: LaunchListViewControllerProtocol,
         networkManager: NetworkManagerProtocol,
         dataManager: DataManagerProtocol,
         rocketID: String)
}

class LaunchPresenter: LaunchPresenterProtocol {

    weak var view: LaunchListViewControllerProtocol?
    let networkManager: NetworkManagerProtocol
    let dataManager: DataManagerProtocol
    let rocketID: String
    
    private var launches: [Launch]?
    
    required init(view: LaunchListViewControllerProtocol,
                  networkManager: NetworkManagerProtocol,
                  dataManager: DataManagerProtocol,
                  rocketID: String) {
        
        self.view = view
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.rocketID = rocketID
        
        fetchLaunches()
    }
    
    private func fetchLaunches() {
        if !DataManager.launches.isEmpty {
            launches = DataManager.getCurrentLaunches(with: rocketID)
            view?.updateUI()
        } else {
            NetworkManager.fetchLaunchesData { [weak self] launches in
                DataManager.launches = launches
                if let id = self?.rocketID {
                    self?.launches = DataManager.getCurrentLaunches(with: id)
                    self?.view?.updateUI()
                }
            }
        }
    }
}
    
