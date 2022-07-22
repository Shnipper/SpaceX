import Foundation

protocol MainViewControllerProtocol: AnyObject {
    func set(rocketMainInfo: RocketMainInfo)
    func set(rocketDetailInfo: RocketDetailInfo)
    func set(rocketImage: Data)
    func rocketChanged()
}

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewControllerProtocol,
         networkManager: NetworkManagerProtocol,
         settingsManager: SettingsManagerProtocol,
         dataManager: DataManagerProtocol)
    
    func setRocketMainInfo()
    func setRocketDetailInfo(with settings: Settings)
    func setRandomRocketImage()
    func set(newRocket: Int)
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    let networkManager: NetworkManagerProtocol
    let settingsManager: SettingsManagerProtocol
    let dataManager: DataManagerProtocol
    
    private var rocket: Rocket?
    
    required init(view: MainViewControllerProtocol,
                  networkManager: NetworkManagerProtocol,
                  settingsManager: SettingsManagerProtocol,
                  dataManager: DataManagerProtocol) {
        
        self.view = view
        self.networkManager = networkManager
        self.settingsManager = settingsManager
        self.dataManager = dataManager
    }
    
    func setRocketMainInfo() {
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
        
        view?.set(rocketMainInfo: rocketMainInfo)
    }
    
    func setRocketDetailInfo(with settings: Settings) {
        guard let rocket = rocket else { return }
        
        let height = settings.height == .meters
            ? rocket.height.meters
            : rocket.height.feet
        let diameter = settings.diameter == .meters
            ? rocket.diameter.meters
            : rocket.diameter.feet
        let mass = settings.mass == .kg
            ? rocket.mass.kg
            : rocket.mass.lb
        let payloadWeight = settings.payloadWeights == .kg
            ? leo(rocket.payloadWeights)?.kg
            : leo(rocket.payloadWeights)?.lb
        
        let rocketDetailInfo = RocketDetailInfo(
            height: "\(height)",
            diameter: "\(diameter)",
            mass: "\(mass)",
            payloadWeight: "\(stringFrom(payloadWeight))"
        )
        
        view?.set(rocketDetailInfo: rocketDetailInfo)
    }
    
    func setRandomRocketImage() {
        guard let randomImageStringURL = rocket?.flickrImages.randomElement() else { return }
        
        if let imageData = DataManager.images[randomImageStringURL] {
            view?.set(rocketImage: imageData)
            
        } else {
            NetworkManager.fetchImage(from: randomImageStringURL) { [weak self] result in
                switch result {
                case .success(let imageData):
                    DataManager.images[randomImageStringURL] = imageData
                    self?.view?.set(rocketImage: imageData)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func set(newRocket: Int) {
        guard DataManager.rockets.count - 1 <= newRocket else { return }
        rocket = DataManager.rockets[newRocket]
    }
    
    private func timeBurnSec(_ stage: Stage) -> String {
        guard let timeToBurn = stage.burnTimeSec else { return "" }
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
