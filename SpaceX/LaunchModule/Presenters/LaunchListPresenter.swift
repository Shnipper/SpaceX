import Foundation

protocol LaunchListViewControllerProtocol: AnyObject {
    
    func updateUI()
}

protocol LaunchListPresenterProtocol: AnyObject {
    init(view: LaunchListViewControllerProtocol,
         networkManager: NetworkManagerProtocol,
         dataManager: DataManagerProtocol,
         rocketID: String,
         rocketName: String)
    
    var rocketID: String { get }
    var rocketName: String { get }
    
}

class LaunchListPresenter: LaunchListPresenterProtocol {

    weak var view: LaunchListViewControllerProtocol?
    let networkManager: NetworkManagerProtocol
    let dataManager: DataManagerProtocol
    let rocketID: String
    let rocketName: String
    
    private var launches: [Launch]?
    
    required init(view: LaunchListViewControllerProtocol,
                  networkManager: NetworkManagerProtocol,
                  dataManager: DataManagerProtocol,
                  rocketID: String,
                  rocketName: String) {
       
        self.view = view
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.rocketID = rocketID
        self.rocketName = rocketName
        
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
    
