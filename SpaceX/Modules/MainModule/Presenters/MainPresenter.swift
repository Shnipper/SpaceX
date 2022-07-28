import Foundation

protocol MainViewControllerProtocol: AnyObject {
    func set(_ rocketMainInfo: RocketMainInfo)
    func setRocketImage(with data: Data)
    func updateRocketDetailInfo()
    func update(pageCount: Int)
    
    init(presenter: MainPresenterProtocol)
}

protocol MainPresenterDelegate: AnyObject {
    func updateRocketDetailInfo()
}

protocol MainPresenterProtocol: MainPresenterDelegate {
    
    init(networkManager: NetworkManagerProtocol,
         settingsManager: SettingsManagerProtocol,
         dataManager: DataManagerProtocol)
    
    var view: MainViewControllerProtocol? { get set }
    
    var getCurrentRocketID: String? { get }
    var getCurrentRocketName: String? { get }
    
    func getRocketDetailInfo(by index: Int) -> RocketDetailInfo?
    func updateRocket(by index: Int)
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    let networkManager: NetworkManagerProtocol
    let settingsManager: SettingsManagerProtocol
    var dataManager: DataManagerProtocol
    
    var getCurrentRocketID: String? { rocket?.id }
    var getCurrentRocketName: String? { rocket?.name }
    
    private var rocket: Rocket? {
        didSet {
            updateRocketMainInfo()
            updateRandomRocketImage()
            updateRocketDetailInfo()
        }
    }
    
    required init(networkManager: NetworkManagerProtocol,
                  settingsManager: SettingsManagerProtocol,
                  dataManager: DataManagerProtocol) {
        
        self.networkManager = networkManager
        self.settingsManager = settingsManager
        self.dataManager = dataManager
    }
    
    func updateRocketDetailInfo() {
        view?.updateRocketDetailInfo()
    }
    
    func updateRocket(by index: Int) {
        if !dataManager.rockets.isEmpty {
            rocket = dataManager.rockets[index]
        } else {
            networkManager.fetchRocketData { [weak self] rockets in
                self?.dataManager.rockets = rockets
                self?.rocket = self?.dataManager.rockets[index]
                
                guard let pageCount = self?.dataManager.rockets.count else { return }
                self?.view?.update(pageCount: pageCount)
            }
        }
    }
    
    func getRocketDetailInfo(by index: Int) -> RocketDetailInfo? {
        guard let rocket = rocket else { return nil }
        let settings = settingsManager.settings
        let height = settings.height == .meters
            ? rocket.height.meters
            : rocket.height.feet
        let diameter = settings.diameter == .meters
            ? rocket.diameter.meters
            : rocket.diameter.feet
        let mass = settings.mass == .kg
            ? rocket.mass.kg
            : rocket.mass.lb
        let payloadWeight = settings.payloadWeight == .kg
            ? leo(rocket.payloadWeights)?.kg
            : leo(rocket.payloadWeights)?.lb
        
        let parameterTitle: String
        let unit: String
        let separator = ", "
        
        switch index {
        case 0:
            parameterTitle = RocketParameters.height.rawValue
            unit = "\(height)" + separator + "\(settings.height.rawValue)"
        case 1:
            parameterTitle = RocketParameters.diameter.rawValue
            unit = "\(diameter)" + separator + "\(settings.diameter.rawValue)"
        case 2:
            parameterTitle = RocketParameters.mass.rawValue
            unit = "\(mass)" + separator + "\(settings.mass.rawValue)"
        case 3:
            parameterTitle = RocketParameters.payloadWeight.rawValue
            unit = "\(stringFrom(payloadWeight))" + separator + "\(settings.payloadWeight.rawValue)"
        default:
            return nil
        }
        
        return RocketDetailInfo(parameterTitle: parameterTitle, unit: unit)
    }
    
    private func updateRocketMainInfo() {
        guard let rocket = rocket else { return }
        
        let rocketMainInfo = RocketMainInfo(
            name: rocket.name,
            firstFlight: changeDateType(inputDate: rocket.firstFlight),
            country: rocket.country,
            costPerLaunch: "\(rocket.costPerLaunch)",
            firstStageEngines: "\(rocket.firstStage.engines)",
            firstStageFuelAmountTons: "\(rocket.firstStage.fuelAmountTons)",
            firstStageBurnTimeSec: timeBurnSec(rocket.firstStage),
            secondStageEngines: "\(rocket.secondStage.engines)",
            secondStageFuelAmountTons: "\(rocket.secondStage.fuelAmountTons)",
            secondStageBurnTimeSec: timeBurnSec(rocket.secondStage)
        )
        
        view?.set(rocketMainInfo)
    }
    
    private func updateRandomRocketImage() {
        guard let randomImageStringURL = rocket?.flickrImages.randomElement() else { return }
        
        if let imageData = dataManager.images[randomImageStringURL] {
            view?.setRocketImage(with: imageData)
            
        } else {
            networkManager.fetchImage(from: randomImageStringURL) { [weak self] result in
                switch result {
                case .success(let imageData):
                    self?.dataManager.images[randomImageStringURL] = imageData
                    self?.view?.setRocketImage(with: imageData)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func timeBurnSec(_ stage: Stage) -> String {
        guard let timeToBurn = stage.burnTimeSec else { return " " }
        return "\(timeToBurn)"
    }
    
    private func changeDateType(inputDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ru_RU")
            outputFormatter.setLocalizedDateFormatFromTemplate("MMMMddYYYY")
            let outputDate = outputFormatter.string(from: date)
            return outputDate
        } else {
            return inputDate
        }
    }
    
    private func leo(_ payloadWeights: [PayloadWeight]) -> PayloadWeight? {
        var value: PayloadWeight? = nil
        for payloadWeight in payloadWeights {
            if payloadWeight.id == "leo" {
                value = payloadWeight
            }
        }
        return value
    }
    
    private func stringFrom(_ payloadWeight: Int?) -> String {
        guard let payloadWeight = payloadWeight else { return "" }
        return "\(payloadWeight)"
    }
}
