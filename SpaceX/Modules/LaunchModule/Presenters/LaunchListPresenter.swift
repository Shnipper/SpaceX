import Foundation

protocol LaunchListViewControllerProtocol: AnyObject {
    
    func updateUI()
    init(presenter: LaunchListPresenterProtocol)
}

protocol LaunchListPresenterProtocol: AnyObject {
    init(networkManager: NetworkManagerProtocol,
         dataManager: DataManagerProtocol,
         rocketID: String?,
         rocketName: String?)
    
    var view: LaunchListViewControllerProtocol? { get set }
    var rocketID: String? { get }
    var rocketName: String? { get }
    var launches: [Launch]? { get }
    
    func getLaunchInfo(from index: Int) -> LaunchInfo?
}

class LaunchListPresenter: LaunchListPresenterProtocol {
    
    let networkManager: NetworkManagerProtocol
    var dataManager: DataManagerProtocol
    let rocketID: String?
    let rocketName: String?
    
    weak var view: LaunchListViewControllerProtocol?
    var launches: [Launch]?
    
    required init(networkManager: NetworkManagerProtocol,
                  dataManager: DataManagerProtocol,
                  rocketID: String?,
                  rocketName: String?) {
       
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.rocketID = rocketID
        self.rocketName = rocketName
        
        fetchLaunches()
    }
    
    func getLaunchInfo(from index: Int) -> LaunchInfo? {
        guard let launch = launches?[index] else { return nil }
        
        let launchInfo = LaunchInfo(launchName: launch.name,
                                    launchDate: formatted(date: launch.dateUtc),
                                    launchStatus: launch.success ?? false)
        
        return launchInfo
    }
    
    private func fetchLaunches() {
        
        guard let rocketID = rocketID else { return }
        if !dataManager.launches.isEmpty {
            launches = dataManager.getCurrentLaunches(with: rocketID)
        } else {
            networkManager.fetchLaunchesData { [weak self] result in
                switch result {
                case .success(let launches):
                    self?.dataManager.launches = launches
                    if let id = self?.rocketID {
                        self?.launches = self?.dataManager.getCurrentLaunches(with: id)
                        self?.view?.updateUI()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func formatted(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        
        if let tempDate = inputFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ru_RU")
            outputFormatter.setLocalizedDateFormatFromTemplate("MMMMddYYYY")
            let outputDate = outputFormatter.string(from: tempDate)
            return outputDate
        } else {
            return date
        }
    }
}
    
